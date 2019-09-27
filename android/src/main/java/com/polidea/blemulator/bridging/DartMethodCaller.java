package com.polidea.blemulator.bridging;

import android.support.annotation.Nullable;
import android.util.Log;

import com.polidea.blemulator.bridging.constants.UpstreamMethodName;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class DartMethodCaller {
    private MethodChannel dartMethodChannel;

    public DartMethodCaller(MethodChannel dartMethodChannel) {
        this.dartMethodChannel = dartMethodChannel;
    }

    public void createClient() {
        HashMap<String, Object> arguments = new HashMap<>();
        dartMethodChannel.invokeMethod(UpstreamMethodName.CREATE_CLIENT,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {
                        Log.e("BLEMULATOR BRIDGE", "CREATE CLIENT SUCCESS");
                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
    }

    public void destroyClient() {
        dartMethodChannel.invokeMethod(UpstreamMethodName.DESTROY_CLIENT,
                null,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {

                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
    }

    public void startDeviceScan() {
        HashMap<String, Object> arguments = new HashMap<>();
        dartMethodChannel.invokeMethod(UpstreamMethodName.START_DEVICE_SCAN,
                arguments,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {

                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
    }

    public void stopDeviceScan() {
        dartMethodChannel.invokeMethod(UpstreamMethodName.STOP_DEVICE_SCAN,
                null,
                new MethodChannel.Result() {
                    @Override
                    public void success(@Nullable Object o) {

                    }

                    @Override
                    public void error(String s, @Nullable String s1, @Nullable Object o) {

                    }

                    @Override
                    public void notImplemented() {

                    }
                });
    }
}
