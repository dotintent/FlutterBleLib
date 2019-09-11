package com.polidea.flutter_ble_lib.event;

import io.flutter.plugin.common.EventChannel;

public class RestoreStateStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink restoreStateSink;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        restoreStateSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        restoreStateSink = null;
    }

    public void onRestoreEvent(Integer restoreStateIdentifier) {
        if (restoreStateSink != null) {
            restoreStateSink.success(restoreStateIdentifier);
        }
    }
}
