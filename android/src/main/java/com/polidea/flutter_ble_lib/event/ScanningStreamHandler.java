package com.polidea.flutter_ble_lib.event;

import com.polidea.flutter_ble_lib.converter.ScanResultJsonConverter;
import com.polidea.multiplatformbleadapter.ScanResult;

import org.json.JSONException;

import io.flutter.plugin.common.EventChannel;

public class ScanningStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink scanResultsSink;
    private ScanResultJsonConverter scanResultJsonConverter = new ScanResultJsonConverter();

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        scanResultsSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        scanResultsSink = null;
    }

    public void onScanResult(ScanResult scanResult) throws JSONException {
        if (scanResultsSink != null) {
            scanResultsSink.success(scanResultJsonConverter.toJson(scanResult));
        }
    }
}
