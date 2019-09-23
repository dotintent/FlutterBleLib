package com.polidea.flutter_ble_lib.event;

import com.polidea.flutter_ble_lib.converter.CharacteristicJsonConverter;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.errors.BleError;

import io.flutter.plugin.common.EventChannel;

public class CharacteristicsMonitorStreamHandler implements EventChannel.StreamHandler {

    private EventChannel.EventSink eventSink;
    private CharacteristicJsonConverter characteristicJsonConverter = new CharacteristicJsonConverter();

    @Override
    synchronized public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    synchronized public void onCancel(Object o) {
        eventSink = null;
    }

    synchronized public void onCharacteristicsUpdate(Characteristic characteristic) {
        if (eventSink != null) {
            eventSink.success(characteristicJsonConverter.toJson(characteristic));
        }
    }

    synchronized public void onError(BleError error) {
        if (eventSink != null) {
            eventSink.error(String.valueOf(error.errorCode.code), error.reason, null);
        }
    }
}
