package com.polidea.flutterblelib;


import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.Nullable;

import com.polidea.flutterblelib.exception.RxBleDeviceNotFoundException;
import com.polidea.flutterblelib.listener.BluetoothStateChangeListener;
import com.polidea.flutterblelib.listener.DeviceConnectionChangeListener;
import com.polidea.flutterblelib.listener.OnErrorAction;
import com.polidea.flutterblelib.listener.OnSuccessAction;
import com.polidea.flutterblelib.utils.StringUtils;
import com.polidea.rxandroidble.RxBleAdapterStateObservable;
import com.polidea.rxandroidble.RxBleClient;
import com.polidea.rxandroidble.RxBleConnection;
import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.internal.RxBleLog;
import com.polidea.rxandroidble.scan.ScanResult;

import rx.Observable;
import rx.Observer;
import rx.Subscription;
import rx.functions.Action0;
import rx.functions.Action1;
import rx.functions.Func1;

public class BleHelper {
    private final Converter converter;

    private final ConnectedDeviceContainer connectedDevices;

    private final ConnectingDevicesContainer connectingDevices;

    private final Context context;

    private final StringUtils stringUtils;

    private RxBleClient rxBleClient;

    private Subscription scanDevicesSubscription;

    @Nullable
    private Subscription adapterStateChangesSubscription;

    private int currentLogLevel = RxBleLog.NONE;

    private BluetoothStateChangeListener bluetoothStateListener = BluetoothStateChangeListener.NULL;
    private DeviceConnectionChangeListener deviceConnectionChangeListener = DeviceConnectionChangeListener.NULL;

    BleHelper(Context context) {
        this.context = context;
        stringUtils = new StringUtils();
        converter = new Converter();
        connectedDevices = new ConnectedDeviceContainer();
        connectingDevices = new ConnectingDevicesContainer();
    }

    private boolean isRxBleDeviceReady(final OnErrorAction error) {
        if (rxBleClient == null) {
            error.onError(new IllegalStateException("BleManager not created when tried to start device scan"));
            return false;
        }
        return true;
    }

    void createClient() {
        rxBleClient = RxBleClient.create(context);
        adapterStateChangesSubscription = monitorAdapterStateChanges(context);
    }

    void registerBluetoothStateChangeListener(BluetoothStateChangeListener bluetoothStateListener) {
        this.bluetoothStateListener = bluetoothStateListener != null ? bluetoothStateListener : BluetoothStateChangeListener.NULL;
    }

    void unregisterBluetoothStateChangeListener() {
        bluetoothStateListener = BluetoothStateChangeListener.NULL;
    }

    void registerDeviceConnectionChangeListener(DeviceConnectionChangeListener deviceConnectionChangeListener) {
        this.deviceConnectionChangeListener = deviceConnectionChangeListener != null ? deviceConnectionChangeListener : DeviceConnectionChangeListener.NULL;
    }

    void unregisterDeviceConnectionChangeListener() {
        deviceConnectionChangeListener = DeviceConnectionChangeListener.NULL;
    }

    void destroyClient() {
        // Subscriptions
        if (adapterStateChangesSubscription != null) {
            adapterStateChangesSubscription.unsubscribe();
            adapterStateChangesSubscription = null;
        }
        if (scanDevicesSubscription != null && !scanDevicesSubscription.isUnsubscribed()) {
            scanDevicesSubscription.unsubscribe();
        }
        scanDevicesSubscription = null;

        connectedDevices.clear();

        unregisterBluetoothStateChangeListener();
        unregisterDeviceConnectionChangeListener();

        rxBleClient = null;
    }

    void startDeviceScan(byte[] scanSettingsBytes,
                         final OnSuccessAction<BleData.ScanResultMessage> success,
                         final OnErrorAction error) {
        if (!isRxBleDeviceReady(error)) {
            return;
        }
        scanDevicesSubscription = rxBleClient
                .scanBleDevices(converter.convertToScanSettings(scanSettingsBytes))
                .subscribe(
                        new Action1<ScanResult>() {
                            @Override
                            public void call(ScanResult scanResult) {
                                success.onSuccess(converter.convertToScanResultMessage(scanResult));
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                error.onError(throwable);
                            }
                        }
                );
    }

    void setLogLevel(BleData.LogLevelMessage logLevel) {
        currentLogLevel = converter.convertLogLevelMessageToInt(logLevel);
        RxBleClient.setLogLevel(currentLogLevel);
    }

    void logLevel(OnSuccessAction<BleData.LogLevelMessage> success) {
        success.onSuccess(converter.convertIntToLogLevel(currentLogLevel));
    }

    public void state(OnSuccessAction<BleData.BluetoothStateMessage> result) {
        result.onSuccess(getCurrentState());
    }

    private Subscription monitorAdapterStateChanges(Context context) {
        return new RxBleAdapterStateObservable(context)
                .map(new Func1<RxBleAdapterStateObservable.BleAdapterState, BleData.BluetoothStateMessage>() {
                    @Override
                    public BleData.BluetoothStateMessage call(RxBleAdapterStateObservable.BleAdapterState bleAdapterState) {
                        return rxAndroidBleAdapterStateToReactNativeBluetoothState(bleAdapterState);
                    }
                })
                .subscribe(new Action1<BleData.BluetoothStateMessage>() {
                    @Override
                    public void call(BleData.BluetoothStateMessage state) {
                        bluetoothStateListener.onSuccess(state);
                    }
                });
    }

    private BleData.BluetoothStateMessage rxAndroidBleAdapterStateToReactNativeBluetoothState(RxBleAdapterStateObservable.BleAdapterState rxBleAdapterState) {
        if (rxBleAdapterState == RxBleAdapterStateObservable.BleAdapterState.STATE_ON) {
            return BleData.BluetoothStateMessage.POWERED_ON;
        }
        if (rxBleAdapterState == RxBleAdapterStateObservable.BleAdapterState.STATE_OFF) {
            return BleData.BluetoothStateMessage.POWERED_OFF;
        }
        return BleData.BluetoothStateMessage.RESETTING;
    }

    private BleData.BluetoothStateMessage getCurrentState() {
        if (!supportsBluetoothLowEnergy()) {
            return BleData.BluetoothStateMessage.UNSUPPORTED;
        }

        final BluetoothManager bluetoothManager = (BluetoothManager) context.getSystemService(Context.BLUETOOTH_SERVICE);
        if (bluetoothManager == null) {
            return BleData.BluetoothStateMessage.POWERED_OFF;
        }
        final BluetoothAdapter bluetoothAdapter = bluetoothManager.getAdapter();
        return nativeAdapterStateToReactNativeBluetoothState(bluetoothAdapter.getState());
    }

    private BleData.BluetoothStateMessage nativeAdapterStateToReactNativeBluetoothState(int adapterState) {
        switch (adapterState) {

            case BluetoothAdapter.STATE_OFF:
                return BleData.BluetoothStateMessage.POWERED_OFF;
            case BluetoothAdapter.STATE_ON:
                return BleData.BluetoothStateMessage.POWERED_ON;
            case BluetoothAdapter.STATE_TURNING_OFF:
                // fallthrough
            case BluetoothAdapter.STATE_TURNING_ON:
                return BleData.BluetoothStateMessage.RESETTING;
            default:
                return BleData.BluetoothStateMessage.UNKNOWN;
        }
    }


    private boolean supportsBluetoothLowEnergy() {
        return context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE);
    }

    void stopDeviceScan() {
        if (scanDevicesSubscription != null && !scanDevicesSubscription.isUnsubscribed()) {
            scanDevicesSubscription.unsubscribe();
        }
        scanDevicesSubscription = null;
    }


    void connectToDevice(byte[] connectToDeviceDataMessageByte,
                         final OnSuccessAction<BleData.ConnectedDeviceMessage> success,
                         final OnErrorAction error) {

        if (!isRxBleDeviceReady(error)) {
            return;
        }
        final BleData.ConnectToDeviceDataMessage connectToDeviceDataMessage
                = converter.convertToConnectToDeviceDataMessage(connectToDeviceDataMessageByte);
        if (connectToDeviceDataMessage == null) {
            error.onError(new IllegalArgumentException("scanResultByte argument contains wrong data"));
            return;
        }
        final String macAddress = connectToDeviceDataMessage.getMacAddress();
        final RxBleDevice rxBleDevice = rxBleClient.getBleDevice(macAddress);
        if (rxBleDevice == null) {
            error.onError(new RxBleDeviceNotFoundException("Not found device for mac address : " + macAddress));
            return;
        }
        final boolean isAutoConnect = connectToDeviceDataMessage.getIsAutoConnect();
        final int requestMtu = connectToDeviceDataMessage.getRequestMtu();
        saveConnectToDevice(rxBleDevice, isAutoConnect, requestMtu, success, error);
    }

    private void saveConnectToDevice(final RxBleDevice device, boolean autoConnect, final int requestMtu,
                                     final OnSuccessAction<BleData.ConnectedDeviceMessage> success, final OnErrorAction error) {
        Observable<RxBleConnection> connect = device
                .establishConnection(autoConnect)
                .doOnUnsubscribe(new Action0() {
                    @Override
                    public void call() {
                        onDeviceDisconnected(device);
                    }
                });

        if (requestMtu > 0) {
            connect = connect.flatMap(new Func1<RxBleConnection, Observable<RxBleConnection>>() {
                @Override
                public Observable<RxBleConnection> call(final RxBleConnection rxBleConnection) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        return rxBleConnection
                                .requestMtu(requestMtu)
                                .map(new Func1<Integer, RxBleConnection>() {
                                    @Override
                                    public RxBleConnection call(Integer integer) {
                                        return rxBleConnection;
                                    }
                                });
                    } else {
                        return Observable.just(rxBleConnection);
                    }
                }
            });
        }

        final Subscription subscription = connect
                .subscribe(new Observer<RxBleConnection>() {
                    @Override
                    public void onCompleted() {
                    }

                    @Override
                    public void onError(Throwable e) {
                        error.onError(e);
                        onDeviceDisconnected(device);
                    }

                    @Override
                    public void onNext(RxBleConnection connection) {
                        BleData.ConnectedDeviceMessage connectedDeviceMessage = BleData.ConnectedDeviceMessage.newBuilder()
                                .setDeviceMessage(BleData.BleDeviceMessage.newBuilder()
                                        .setMacAddress(stringUtils.safeNullInstance(device.getMacAddress()))
                                        .setName(stringUtils.safeNullInstance(device.getName()))
                                )
                                .setMtu(connection.getMtu())
                                .setRssi(-1)
                                .build();
                        connectedDevices.put(device.getMacAddress(), connectedDeviceMessage);
                        success.onSuccess(connectedDeviceMessage);
                    }
                });

        connectingDevices.replaceConnectingSubscription(device.getMacAddress(), subscription);
    }


    private void onDeviceDisconnected(RxBleDevice device) {
        final BleData.ConnectedDeviceMessage connectedDevice = connectedDevices.remove(device.getMacAddress());
        if (connectedDevice == null) {
            return;
        }

        // cleanServicesAndCharacteristicsForDevice(jsDevice);
        deviceConnectionChangeListener.onSuccess(connectedDevice.getDeviceMessage());
        connectingDevices.removeConnectingDeviceSubscription(device.getMacAddress());
    }

    void isDeviceConnected(String macAddress, OnSuccessAction<Boolean> onSuccessAction, OnErrorAction onErrorAction) {
        if (rxBleClient == null) {
            throw new IllegalStateException("BleManager not created when tried to cancel device connection");
        }

        final RxBleDevice device = rxBleClient.getBleDevice(macAddress);
        if (device == null) {
            onErrorAction.onError(new RxBleDeviceNotFoundException("Can't find device with id : " + macAddress));
            return;
        }

        boolean connected = device.getConnectionState()
                .equals(RxBleConnection.RxBleConnectionState.CONNECTED);
        onSuccessAction.onSuccess(connected);
    }
}