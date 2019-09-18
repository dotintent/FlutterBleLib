package com.polidea.flutter_ble_lib.event;

import com.polidea.flutter_ble_lib.converter.BleErrorJsonConverter;
import com.polidea.flutter_ble_lib.converter.ScanResultJsonConverter;
import com.polidea.multiplatformbleadapter.ScanResult;
import com.polidea.multiplatformbleadapter.errors.BleError;

import io.flutter.plugin.common.EventChannel;

public class ScanningStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink scanResultsSink;
    private ScanResultJsonConverter scanResultJsonConverter = new ScanResultJsonConverter();
    private BleErrorJsonConverter bleErrorJsonConverter = new BleErrorJsonConverter();

    @Override
    synchronized public void onListen(Object o, EventChannel.EventSink eventSink) {
        scanResultsSink = eventSink;
    }

    @Override
    synchronized public void onCancel(Object o) {
        scanResultsSink = null;
    }

    synchronized public void onScanResult(ScanResult scanResult) {
        if (scanResultsSink != null) {
            scanResultsSink.success(scanResultJsonConverter.toJson(scanResult));
        }
    }

    synchronized public void onError(BleError error) {
        if (scanResultsSink != null) {
            scanResultsSink.error(
                    String.valueOf(error.errorCode.code),
                    error.reason,
                    bleErrorJsonConverter.toJson(error));
            scanResultsSink.endOfStream();
        }
    }

    synchronized public void onComplete() {
        if (scanResultsSink != null) {
            scanResultsSink.endOfStream();
        }
    }
}
