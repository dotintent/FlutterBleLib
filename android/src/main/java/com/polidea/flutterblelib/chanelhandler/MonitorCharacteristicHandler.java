package com.polidea.flutterblelib.chanelhandler;

import com.polidea.flutterblelib.BleData;

import io.flutter.plugin.common.EventChannel;

public class MonitorCharacteristicHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink monitorCharacteristicSlink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        monitorCharacteristicSlink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        monitorCharacteristicSlink = null;
    }

    public void handleMonitorCharacteristic(BleData.MonitorCharacteristicMessage monitorCharacteristicMessage) {
        if (monitorCharacteristicSlink != null) {
            monitorCharacteristicSlink.success(monitorCharacteristicMessage.toByteArray());
        }
    }
}