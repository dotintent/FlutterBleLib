package com.polidea.blemulator;

import android.content.Context;
import android.support.annotation.NonNull;

import com.polidea.blemulator.bridging.DartMethodCaller;
import com.polidea.blemulator.bridging.constants.ChannelName;
import com.polidea.blemulator.bridging.constants.MethodName;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.BleAdapterCreator;
import com.polidea.multiplatformbleadapter.BleAdapterFactory;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SimulatorPlugin implements MethodChannel.MethodCallHandler {

    private DartMethodCaller dartMethodCaller;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel downstream = new MethodChannel(registrar.messenger(), ChannelName.TO_JAVA);
        MethodChannel upstream = new MethodChannel(registrar.messenger(), ChannelName.TO_DART);

        downstream.setMethodCallHandler(new SimulatorPlugin(upstream));
    }

    private SimulatorPlugin(MethodChannel upstream) {
        dartMethodCaller = new DartMethodCaller(upstream);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case MethodName.SIMULATE:
                switchToSimulation(result);
                return;
            default:
                result.notImplemented();
                return;
        }
    }

    private void switchToSimulation(MethodChannel.Result result) {
        BleAdapterFactory.setBleAdapterCreator(new BleAdapterCreator() {
            @Override
            public BleAdapter createAdapter(Context context) {
                return new SimulatedAdapter(dartMethodCaller);
            }
        });
        result.success(null);
    }
}
