package com.polidea.flutter_ble_lib;

import android.content.Context;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.constant.ChannelName;
import com.polidea.flutter_ble_lib.event.AdapterStateStreamHandler;
import com.polidea.flutter_ble_lib.event.RestoreStateStreamHandler;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.BleModule;
import com.polidea.multiplatformbleadapter.OnEventCallback;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterBleLibPlugin implements MethodCallHandler {

    private BleAdapter bleAdapter;
    private AdapterStateStreamHandler adapterStateStreamHandler;
    private RestoreStateStreamHandler restoreStateStreamHandler;

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), ChannelName.FLUTTER_BLE_LIB);
        final EventChannel bluetoothStateChannel = new EventChannel(registrar.messenger(), ChannelName.ADAPTER_STATE_CHANGES);
        final EventChannel restoreStateChannel = new EventChannel(registrar.messenger(), ChannelName.STATE_RESTORE_EVENTS);
        final FlutterBleLibPlugin plugin = new FlutterBleLibPlugin(registrar.context());
        bluetoothStateChannel.setStreamHandler(plugin.adapterStateStreamHandler);
        restoreStateChannel.setStreamHandler(plugin.restoreStateStreamHandler);
        channel.setMethodCallHandler(plugin);
    }

    private FlutterBleLibPlugin(Context context) {
        bleAdapter = new BleModule(context);
        adapterStateStreamHandler = new AdapterStateStreamHandler();
        restoreStateStreamHandler = new RestoreStateStreamHandler();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case MethodName.CREATE_CLIENT:
                createClient(call, result);
                break;
            case MethodName.DESTROY_CLIENT:
                destroyClient(result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void createClient(MethodCall call, Result result) {
        bleAdapter.createClient(call.<String>argument(ArgumentKey.RESTORE_STATE_IDENTIFIER),
                new OnEventCallback<String>() {
                    @Override
                    public void onEvent(String adapterState) {
                        adapterStateStreamHandler.onNewAdapterState(adapterState);
                    }
                }, new OnEventCallback<Integer>() {
                    @Override
                    public void onEvent(Integer restoreStateIdentifier) {
                        restoreStateStreamHandler.onRestoreEvent(restoreStateIdentifier);
                    }
                });
        result.success(null);
    }

    private void destroyClient(Result result) {
        bleAdapter.destroyClient();
        result.success(null);
    }

}
