package com.polidea.blemulator.bridging;

import android.support.annotation.Nullable;
import android.util.Log;

import com.polidea.blemulator.bridging.constants.DartMethodName;

import java.util.HashMap;

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
}
