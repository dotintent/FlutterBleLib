package com.polidea.flutter_ble_lib.delegate;

import android.support.annotation.NonNull;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.event.ConnectionStateStreamHandler;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.ConnectionOptions;
import com.polidea.multiplatformbleadapter.ConnectionState;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnEventCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.RefreshGattMoment;
import com.polidea.multiplatformbleadapter.errors.BleError;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DeviceConnectionDelegate implements MethodChannel.MethodCallHandler {

    private BleAdapter bleAdapter;
    private ConnectionStateStreamHandler streamHandler;

    public DeviceConnectionDelegate(BleAdapter bleAdapter, ConnectionStateStreamHandler streamHandler) {
        this.bleAdapter = bleAdapter;
        this.streamHandler = streamHandler;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String deviceId = call.argument(ArgumentKey.DEVICE_IDENTIFIER);
        switch (call.method) {
            case MethodName.CONNECT_TO_DEVICE:
                connectToDevice(deviceId,
                        call.<Boolean>argument(ArgumentKey.IS_AUTO_CONNECT),
                        call.<Integer>argument(ArgumentKey.REQUEST_MTU),
                        call.<Boolean>argument(ArgumentKey.REFRESH_GATT),
                        call.<Long>argument(ArgumentKey.TIMEOUT_MILLIS),
                        result);
                return;
            case MethodName.IS_DEVICE_CONNECTED:
                isDeviceConnected(deviceId, result);
                return;
            case MethodName.OBSERVE_CONNECTION_STATE:
                observeConnectionState(deviceId, call.<Boolean>argument(ArgumentKey.EMIT_CURRENT_VALUE), result);
                return;
            case MethodName.CANCEL_CONNECTION:
                cancelConnection(deviceId, result);
                return;
            default:
                throw new IllegalStateException("");
        }
    }

    private void connectToDevice(String deviceId, Boolean isAutoConnect, Integer requestMtu, Boolean refreshGatt, Long timeoutMillis, @NonNull final MethodChannel.Result result) {
        RefreshGattMoment refreshGattMoment = null;
        if (refreshGatt) refreshGattMoment = RefreshGattMoment.ON_CONNECTED;
        bleAdapter.connectToDevice(deviceId,
                new ConnectionOptions(isAutoConnect, requestMtu, refreshGattMoment, timeoutMillis, 0 /* BluetoothGatt.CONNECTION_PRIORITY_BALANCED */),
                new OnSuccessCallback<Device>() {
                    @Override
                    public void onSuccess(Device data) {
                        result.success(null);
                    }
                }, new OnEventCallback<ConnectionState>() {
                    @Override
                    public void onEvent(ConnectionState data) {
                        streamHandler.onNewConnectionState(data);
                    }
                },
                new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, null); //TODO @BartoszWilk convert this error
                    }
                });
    }

    private void observeConnectionState(String deviceId, boolean emitCurrentValue, @NonNull final MethodChannel.Result result) {
        //emit current value if needed; rest is published automatically through connectToDevice()
        if (emitCurrentValue)
            bleAdapter.isDeviceConnected(deviceId, new OnSuccessCallback<Boolean>() {
                @Override
                public void onSuccess(Boolean data) {
                    if (data)
                        streamHandler.onNewConnectionState(ConnectionState.CONNECTED);
                    else
                        streamHandler.onNewConnectionState(ConnectionState.DISCONNECTED);
                }
            }, new OnErrorCallback() {
                @Override
                public void onError(BleError error) {
                    result.error(String.valueOf(error.errorCode.code), error.reason, null); //TODO @BartoszWilk convert this error
                }
            });
    }

    private void isDeviceConnected(String deviceId, @NonNull final MethodChannel.Result result) {
        bleAdapter.isDeviceConnected(deviceId, new OnSuccessCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean data) {

            }
        }, new OnErrorCallback() {
            @Override
            public void onError(BleError error) {
                result.error(String.valueOf(error.errorCode.code), error.reason, null); //TODO @BartoszWilk convert this error
            }
        });
    }

    private void cancelConnection(String deviceId, @NonNull final MethodChannel.Result result) {
        bleAdapter.cancelDeviceConnection(deviceId, new OnSuccessCallback<Device>() {
            @Override
            public void onSuccess(Device data) {
                result.success(null);
            }
        }, new OnErrorCallback() {
            @Override
            public void onError(BleError error) {
                result.error(String.valueOf(error.errorCode.code), error.reason, null); //TODO @BartoszWilk convert this error
            }
        });
    }
}
