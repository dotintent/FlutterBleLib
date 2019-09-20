package com.polidea.flutter_ble_lib.event;

import io.flutter.plugin.common.EventChannel;

public class ConnectionStateStreamHandler implements EventChannel.StreamHandler {
    private EventChannel.EventSink eventSink;

    @Override
    synchronized public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    synchronized public void onCancel(Object o) {
        eventSink = null;
    }

    synchronized public void onNewConnectionState(String newState) {
        if (eventSink != null) {
            eventSink.success(newState);
        }
    }
}
