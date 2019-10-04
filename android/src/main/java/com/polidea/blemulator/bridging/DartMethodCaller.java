package com.polidea.blemulator.bridging;

import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.Nullable;
import android.util.Log;

import com.polidea.blemulator.DiscoveryResponseParser;
import com.polidea.blemulator.bridging.constants.ArgumentName;
import com.polidea.blemulator.bridging.constants.DartMethodName;
import com.polidea.blemulator.bridging.constants.SimulationArgumentName;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.ConnectionOptions;
import com.polidea.multiplatformbleadapter.ConnectionState;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnEventCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.errors.BleError;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodChannel;

public class DartMethodCaller {

    private static final String TAG = DartMethodCaller.class.getSimpleName();
    private MethodChannel dartMethodChannel;

    public DartMethodCaller(MethodChannel dartMethodChannel) {
        this.dartMethodChannel = dartMethodChannel;
    }

    public void createClient() {
        HashMap<String, Object> arguments = new HashMap<>();
        dartMethodChannel.invokeMethod(DartMethodName.CREATE_CLIENT,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {
                        Log.d(TAG, "createClient SUCCESS");
                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {
                        Log.e(TAG, s);
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "CREATE CLIENT not implemented");
                    }
                });
    }

    public void destroyClient() {
        dartMethodChannel.invokeMethod(DartMethodName.DESTROY_CLIENT,
                null,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {
                        Log.d(TAG, "destroyClient SUCCESS");
                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {
                        Log.e(TAG, s);
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "DESTROY CLIENT not implemented");
                    }
                });
    }

    public void startDeviceScan() {
        HashMap<String, Object> arguments = new HashMap<>();
        dartMethodChannel.invokeMethod(DartMethodName.START_DEVICE_SCAN,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {
                        Log.d(TAG, "startDeviceScan SUCCESS");
                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {
                        Log.e(TAG, s);
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "START DEVICE SCAN not implemented");
                    }
                });
    }

    public void stopDeviceScan() {
        dartMethodChannel.invokeMethod(DartMethodName.STOP_DEVICE_SCAN,
                null,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {
                        Log.d(TAG, "stopDeviceScan SUCCESS");
                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {
                        Log.e(TAG, s);
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "STOP DEVICE SCAN not implemented");
                    }
                });
    }

    public void connectToDevice(final String deviceIdentifier,
                                final String name,
                                ConnectionOptions connectionOptions,
                                final OnSuccessCallback<Device> onSuccessCallback,
                                final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>();
        arguments.put(SimulationArgumentName.DEVICE_ID, deviceIdentifier);
        dartMethodChannel.invokeMethod(DartMethodName.CONNECT_TO_DEVICE, arguments, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object o) {
                Log.d(TAG, "connectToDevice SUCCESS");
                onSuccessCallback.onSuccess(new Device(deviceIdentifier, name));
            }

            @Override
            public void error(String s, @Nullable String s1, @Nullable Object o) {
                Log.e(TAG, s);
                onErrorCallback.onError(objectToBleError(o));
            }

            @Override
            public void notImplemented() {
                Log.e(TAG, "CONNECT TO DEVICE not implemented");
            }
        });
    }

    public void isDeviceConnected(String deviceIdentifier,
                                  final OnSuccessCallback<Boolean> onSuccessCallback,
                                  final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>();
        arguments.put(SimulationArgumentName.DEVICE_ID, deviceIdentifier);
        dartMethodChannel.invokeMethod(DartMethodName.IS_DEVICE_CONNECTED, arguments, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object o) {
                Log.d(TAG, "connectToDevice SUCCESS");
                onSuccessCallback.onSuccess((Boolean) o);
            }

            @Override
            public void error(String s, @Nullable String s1, @Nullable Object o) {
                Log.e(TAG, s);
                onErrorCallback.onError(objectToBleError(o));
            }

            @Override
            public void notImplemented() {
                Log.e(TAG, "CONNECT TO DEVICE not implemented");
            }
        });
    }

    public void disconnectOrCancelConnection(final String deviceIdentifier,
                                             final String name,
                                             final OnSuccessCallback<Device> onSuccessCallback,
                                             final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>();
        arguments.put(SimulationArgumentName.DEVICE_ID, deviceIdentifier);
        dartMethodChannel.invokeMethod(DartMethodName.DISCONNECT_OR_CANCEL_CONNECTION, arguments, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object o) {
                Log.d(TAG, "connectToDevice SUCCESS");
                onSuccessCallback.onSuccess(new Device(deviceIdentifier, name));
            }

            @Override
            public void error(String s, @Nullable String s1, @Nullable Object o) {
                Log.e(TAG, s);
                onErrorCallback.onError(objectToBleError(o));
            }

            @Override
            public void notImplemented() {
                Log.e(TAG, "CONNECT TO DEVICE not implemented");
            }
        });
    }

    private BleError objectToBleError(Object o) {
        Map<String, Object> error = (Map<String, Object>) o;
        if (error.containsKey("errorCode") && error.containsKey("reason")) {
            for (BleErrorCode errorCode : BleErrorCode.values()) {
                if (errorCode.code == (Integer) error.get("errorCode")) {
                    return new BleError(errorCode, (String) error.get("reason"), 0);
                }
            }
        }
        return new BleError(BleErrorCode.UnknownError, "Wrong format of error from Dart BLEmulator", 0);
    }

    public void discoverAllServicesAndCharacteristicsForDevice(
            final String deviceIdentifier,
            final String name,
            String transactionId,
            final DiscoveryResponseParser parser,
            final OnSuccessCallback<Device> onSuccessCallback,
            final OnErrorCallback onErrorCallback) {
        dartMethodChannel.invokeMethod(DartMethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS, new HashMap<String, Object>() {{
            put(ArgumentName.IDENTIFIER, deviceIdentifier);
        }}, new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object o) {
                //TODO parse response
                parser.parseDiscoveryResponse(deviceIdentifier, o);
                onSuccessCallback.onSuccess(new Device(deviceIdentifier, name));
            }

            @Override
            public void error(String s, @Nullable String s1, @Nullable Object o) {
                //TODO convert error
//                onErrorCallback
            }

            @Override
            public void notImplemented() {
                Log.e(TAG, DartMethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS + " not implemented");
            }
        });
    }
}
