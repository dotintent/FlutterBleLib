package com.polidea.flutter_ble_lib.event;


import io.flutter.plugin.common.EventChannel;

public class AdapterStateStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink adapterStateSink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        adapterStateSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        adapterStateSink = null;
    }

    public void onNewAdapterState(String bluetoothAdapterState) {
        if (adapterStateSink != null) {
            adapterStateSink.success(bluetoothAdapterState);
        }
    }
}
