package com.polidea.flutterblelib;


import android.content.Context;

import com.polidea.flutterblelib.chanelhandler.ScanDevicesHandler;
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

    private BleHelper bleHelper;


    private FlutterBleLibPlugin(Context context) {
        bleHelper = new BleHelper(context);
        scanDevicesHandler = new ScanDevicesHandler();
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_ble_lib");
        final EventChannel scanDevicesChannel = new EventChannel(registrar.messenger(), "flutter_ble_lib/" + BleMethod.scanDevices);
        final FlutterBleLibPlugin handler = new FlutterBleLibPlugin(registrar.activity().getApplicationContext());
        channel.setMethodCallHandler(handler);
        scanDevicesChannel.setStreamHandler(handler.scanDevicesHandler);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case BleMethod.scanDevices: {
                scanDevices(call, result);
                return;
            }
            case BleMethod.stopScanDevices: {
                bleHelper.stopScanDevices();
                return;
            }
            default:
                result.notImplemented();

        }
    }

    private void scanDevices(MethodCall call, final Result result) {
        final byte[] scanSettingsByte = call.arguments();
        bleHelper.scanDevices(scanSettingsByte,
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
}
