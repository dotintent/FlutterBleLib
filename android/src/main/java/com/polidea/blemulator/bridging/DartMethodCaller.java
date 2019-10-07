package com.polidea.blemulator.bridging;

import android.support.annotation.Nullable;
import android.util.Log;

import com.polidea.blemulator.bridging.constants.DartMethodName;
import com.polidea.blemulator.bridging.decoder.CharacteristicDartValueDecoder;
import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.errors.BleError;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class DartMethodCaller {

    private static final String TAG = DartMethodCaller.class.getSimpleName();
    private MethodChannel dartMethodChannel;
    private CharacteristicDartValueDecoder characteristicJsonDecoder = new CharacteristicDartValueDecoder();

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

    public void readCharacteristicForDevice(
            final String deviceIdentifier,
            final String serviceUUID,
            final String characteristicUUID,
            final OnSuccessCallback<Characteristic> onSuccessCallback,
            final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>() {{
            put(ArgumentKey.DEVICE_IDENTIFIER, deviceIdentifier);
            put(ArgumentKey.SERVICE_UUID, serviceUUID);
            put(ArgumentKey.CHARACTERISTIC_UUID, characteristicUUID);
        }};
        dartMethodChannel.invokeMethod(DartMethodName.READ_CHARACTERISTIC_FOR_DEVICE,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object characteristicJsonObject) {
                        onSuccessCallback.onSuccess(characteristicJsonDecoder.decode(characteristicJsonObject));
                    }

                    @Override
                    public void error(String errorCode, @Nullable String message, @Nullable Object bleErrorJsonObject) {
                        onErrorCallback.onError(new BleError(BleErrorCode.UnknownError, message, 0)); //TODO Add proper error parsing here
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "readCharacteristicForDevice not implemented");
                    }
                });
    }

    public void readCharacteristicForService(
            final int serviceIdentifier,
            final String characteristicUUID,
            final OnSuccessCallback<Characteristic> onSuccessCallback,
            final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>() {{
            put(ArgumentKey.SERVICE_IDENTIFIER, serviceIdentifier);
            put(ArgumentKey.CHARACTERISTIC_UUID, characteristicUUID);
        }};
        dartMethodChannel.invokeMethod(DartMethodName.READ_CHARACTERISTIC_FOR_SERVICE,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object characteristicJsonObject) {
                        onSuccessCallback.onSuccess(characteristicJsonDecoder.decode(characteristicJsonObject));
                    }

                    @Override
                    public void error(String errorCode, @Nullable String message, @Nullable Object bleErrorJsonObject) {
                        onErrorCallback.onError(new BleError(BleErrorCode.UnknownError, message, 0)); //TODO Add proper error parsing here
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "readCharacteristicForService not implemented");
                    }
                });
    }

    public void readCharacteristic(
            final int characteristicIdentifier,
            final OnSuccessCallback<Characteristic> onSuccessCallback,
            final OnErrorCallback onErrorCallback) {
        HashMap<String, Object> arguments = new HashMap<String, Object>() {{
            put(ArgumentKey.CHARACTERISTIC_IDENTIFIER, characteristicIdentifier);
        }};
        dartMethodChannel.invokeMethod(DartMethodName.READ_CHARACTERISTIC_FOR_IDENTIFIER,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object characteristicJsonObject) {
                        onSuccessCallback.onSuccess(characteristicJsonDecoder.decode(characteristicJsonObject));
                    }

                    @Override
                    public void error(String errorCode, @Nullable String message, @Nullable Object bleErrorJsonObject) {
                        onErrorCallback.onError(new BleError(BleErrorCode.UnknownError, message, 0)); //TODO Add proper error parsing here
                    }

                    @Override
                    public void notImplemented() {
                        Log.e(TAG, "readCharacteristic not implemented");
                    }
                });
    }
}
