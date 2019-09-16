package com.polidea.flutter_ble_lib.event;

import com.polidea.multiplatformbleadapter.ConnectionState;

import io.flutter.plugin.common.EventChannel;

public class ConnectionStateStreamHandler implements EventChannel.StreamHandler {
    private EventChannel.EventSink eventSink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        eventSink = null;
    }

    public void onNewConnectionState(ConnectionState newState) {
        if (eventSink != null) {
            eventSink.success(newState.value);
        }
    }
}
