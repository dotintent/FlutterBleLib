package com.polidea.flutter_ble_lib.event;

import android.util.Log;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.ChannelName;
import com.polidea.flutter_ble_lib.converter.BleErrorJsonConverter;
import com.polidea.flutter_ble_lib.converter.ScanResultJsonConverter;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnEventCallback;
import com.polidea.multiplatformbleadapter.ScanResult;
import com.polidea.multiplatformbleadapter.errors.BleError;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ScanningStreamHandler implements EventChannel.StreamHandler {
    /**
     * @see MethodCall#argument(java.lang.String)
     */
    @SuppressWarnings("unchecked")
    public static <T> T argument(Object arguments, String key) {
        if (arguments == null) {
            return null;
        } else if (arguments instanceof Map) {
            return (T) ((Map<?, ?>) arguments).get(key);
        } else if (arguments instanceof JSONObject) {
            return (T) ((JSONObject) arguments).opt(key);
        } else {
            throw new ClassCastException();
        }
    }

    private EventChannel.EventSink scanResultsSink;
    private final ScanResultJsonConverter scanResultJsonConverter = new ScanResultJsonConverter();
    private final BleErrorJsonConverter bleErrorJsonConverter = new BleErrorJsonConverter();
    private BleAdapter bleAdapter;

    synchronized public void attachAdapter(BleAdapter bleAdapter) {
        this.bleAdapter = bleAdapter;
    }

    synchronized public void detachAdapter() {
        cancelPreviousScanning("detach adapter");
        bleAdapter = null;
    }

    private void cancelPreviousScanning(String reason) {
        if (scanResultsSink != null) {
            onError(scanResultsSink, new BleError(BleErrorCode.OperationCancelled, reason, null));
            scanResultsSink = null;
        }
        bleAdapter.stopDeviceScan();
    }

    synchronized public void stopDeviceScan(MethodChannel.Result result) {
        cancelPreviousScanning("stop device scan");
        result.success(null);
    }

    @Override
    synchronized public void onListen(Object arguments, final EventChannel.EventSink eventSink) {
        Log.d("FlutterBleLibPlugin", "on native side listen: " + ChannelName.SCANNING_EVENTS);
        cancelPreviousScanning("Restart the scan");
        scanResultsSink = eventSink;

        List<String> uuids = argument(arguments, ArgumentKey.UUIDS);
        int scanMode = argument(arguments, ArgumentKey.SCAN_MODE);
        int callbackType = argument(arguments, ArgumentKey.CALLBACK_TYPE);
        bleAdapter.startDeviceScan(uuids.toArray(new String[uuids.size()]), scanMode, callbackType,
                new OnEventCallback<ScanResult>() {
                    @Override
                    public void onEvent(ScanResult data) {
                        onScanResult(eventSink, data);
                    }
                },
                new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        ScanningStreamHandler.this.onError(eventSink, error);
                    }
                }
        );
    }

    @Override
    synchronized public void onCancel(Object arguments) {
        Log.d("FlutterBleLibPlugin", "on native side cancel: " + ChannelName.SCANNING_EVENTS);
        bleAdapter.stopDeviceScan();
        scanResultsSink = null;
    }

    private void onScanResult(EventChannel.EventSink eventSink, ScanResult scanResult) {
        eventSink.success(scanResultJsonConverter.toJson(scanResult));
    }

    private void onError(EventChannel.EventSink eventSink, BleError error) {
        eventSink.error(
                String.valueOf(error.errorCode.code),
                error.reason,
                bleErrorJsonConverter.toJson(error));
    }
}
