package com.polidea.flutterblelib.chanelhandler;

import com.polidea.flutterblelib.BleData;

import io.flutter.plugin.common.EventChannel;

public class DeviceConnectionChangedHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink deviceConnectionChangeSlink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        deviceConnectionChangeSlink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        deviceConnectionChangeSlink = null;
    }

    public void handleBluetoothState(BleData.BleDeviceMessage bleDeviceMessage) {
        if (deviceConnectionChangeSlink != null) {
            deviceConnectionChangeSlink.success(bleDeviceMessage.toByteArray());
        }
    }
}