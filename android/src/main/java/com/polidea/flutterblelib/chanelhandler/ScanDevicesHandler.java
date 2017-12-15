package com.polidea.flutterblelib.chanelhandler;

import com.polidea.flutterblelib.BleData;

import io.flutter.plugin.common.EventChannel;

public class ScanDevicesHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink scanDevicesSlink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        scanDevicesSlink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        scanDevicesSlink = null;
    }

    public void handleScanDevice(BleData.ScanResultMessage scanResultMessage) {
        if (scanDevicesSlink != null) {
            scanDevicesSlink.success(scanResultMessage.toByteArray());
        }
    }
}