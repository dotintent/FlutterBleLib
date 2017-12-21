package com.polidea.flutterblelib.chanelhandler;

import com.polidea.flutterblelib.BleData;

import io.flutter.plugin.common.EventChannel;

public class BluetoothStateHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink bluetoothStateSlink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        bluetoothStateSlink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        bluetoothStateSlink = null;
    }

    public void handleBluetoothState(BleData.BluetoothStateMessage bluetoothStateMessage) {
        if (bluetoothStateSlink != null) {
            bluetoothStateSlink.success(bluetoothStateMessage.ordinal());
        }
    }
}