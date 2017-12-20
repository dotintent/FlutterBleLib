package com.polidea.flutterblelib;


import android.content.Context;
import android.util.Log;

import com.polidea.flutterblelib.chanelhandler.BluetoothStateHandler;
import com.polidea.flutterblelib.chanelhandler.ScanDevicesHandler;
import com.polidea.flutterblelib.listener.Namespace;
import com.polidea.flutterblelib.listener.OnErrorAction;
import com.polidea.flutterblelib.listener.OnSuccessAction;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterBleLibPlugin implements MethodCallHandler {

    public static final String TAG = "FlutterBleLibPlugin";
    private ScanDevicesHandler scanDevicesHandler;
    private BluetoothStateHandler bluetoothStateHandler;

    private BleHelper bleHelper;


    private FlutterBleLibPlugin(Context context) {
        bleHelper = new BleHelper(context);
        scanDevicesHandler = new ScanDevicesHandler();
        bluetoothStateHandler = new BluetoothStateHandler();
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), Namespace.flutter_ble_lib);
        final EventChannel scanDevicesChannel = new EventChannel(registrar.messenger(), Namespace.flutter_ble_lib_scanDevices);
        final EventChannel bluetoothStateChanel = new EventChannel(registrar.messenger(), Namespace.flutter_ble_lib_stateChange);
        final FlutterBleLibPlugin handler = new FlutterBleLibPlugin(registrar.activity().getApplicationContext());
        channel.setMethodCallHandler(handler);
        scanDevicesChannel.setStreamHandler(handler.scanDevicesHandler);
        bluetoothStateChanel.setStreamHandler(handler.bluetoothStateHandler);
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case BleMethod.createClient: {
                bleHelper.createClient(new OnSuccessAction<BleData.BluetoothStateMessage>() {
                    @Override
                    public void onSuccess(BleData.BluetoothStateMessage success) {
                        bluetoothStateHandler.handleBluetoothState(success);
                    }
                });
                return;
            }
            case BleMethod.destroyClient: {
                bleHelper.destroyClient();
                return;
            }
            case BleMethod.setLogLevel: {
                bleHelper.setLogLevel(BleData.LogLevelMessage.valueOf(call.arguments.toString()));
                return;
            }
            case BleMethod.logLevel: {
                bleHelper.logLevel(new OnSuccessAction<BleData.LogLevelMessage>() {
                    @Override
                    public void onSuccess(BleData.LogLevelMessage logLevelMessage) {
                        result.success(logLevelMessage.ordinal());
                    }
                });
                return;
            }
            case BleMethod.state: {
                bleHelper.state(new OnSuccessAction<BleData.BluetoothStateMessage>() {
                    @Override
                    public void onSuccess(BleData.BluetoothStateMessage success) {
                        result.success(success.ordinal());
                    }
                });
                return;
            }
            case BleMethod.startDeviceScan: {
                startDeviceScan(call, result);
                return;
            }
            case BleMethod.stopDeviceScan: {
                bleHelper.stopDeviceScan();
                return;
            }
            case BleMethod.connectToDevice: {
                connectToDevice(call, result);
                return;
            }
            default:
                result.notImplemented();

        }
    }

    private void startDeviceScan(MethodCall call, final Result result) {
        final byte[] scanResultMessageByte = call.arguments();
        bleHelper.startDeviceScan(scanResultMessageByte,
                new OnSuccessAction<BleData.ScanResultMessage>() {
                    @Override
                    public void onSuccess(BleData.ScanResultMessage scanResultMessage) {
                        scanDevicesHandler.handleScanDevice(scanResultMessage);
                    }
                },
                new OnErrorAction() {
                    @Override
                    public void onError(Throwable t) {
                        result.error("Scan device error", t.getMessage(), t);
                    }
                }
        );
        result.success(null);
    }

    private void connectToDevice(final MethodCall call, final Result result) {
        final byte[] connectToDeviceDataMessageByte = call.arguments();
        bleHelper.connectToDevice(
                connectToDeviceDataMessageByte,
                new OnSuccessAction<BleData.ConnectedDeviceMessage>() {
                    @Override
                    public void onSuccess(BleData.ConnectedDeviceMessage connectedDeviceMessage) {
                        result.success(connectedDeviceMessage.toByteArray());
                    }
                },
                new OnErrorAction() {
                    @Override
                    public void onError(Throwable t) {
                        result.error("Error occours", t.getMessage(), t);
                    }
                }

        );
    }

}
