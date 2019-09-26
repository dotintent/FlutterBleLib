package com.polidea.flutter_ble_lib.constant;

public interface ChannelName {
    String FLUTTER_BLE_LIB = "flutter_ble_lib";
    String ADAPTER_STATE_CHANGES = FLUTTER_BLE_LIB + "/stateChanges";
    String STATE_RESTORE_EVENTS = FLUTTER_BLE_LIB + "/stateRestoreEvents";
    String SCANNING_EVENTS = FLUTTER_BLE_LIB + "/scanningEvents";
    String CONNECTION_STATE_CHANGE_EVENTS = FLUTTER_BLE_LIB + "/connectionStateChangeEvents";
    String MONITOR_CHARACTERISTIC = FLUTTER_BLE_LIB + "/monitorCharacteristic";
}
