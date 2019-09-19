package com.polidea.flutter_ble_lib.constant;

public interface MethodName {
    String CREATE_CLIENT = "createClient";
    String DESTROY_CLIENT = "destroyClient";
    String START_DEVICE_SCAN = "startDeviceScan";
    String STOP_DEVICE_SCAN = "stopDeviceScan";

    String CONNECT_TO_DEVICE = "connectToDevice";
    String IS_DEVICE_CONNECTED = "isDeviceConnected";
    String OBSERVE_CONNECTION_STATE = "observeConnectionState";
    String CANCEL_CONNECTION = "cancelConnection";

    String DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS = "discoverAllServicesAndCharacteristics";
    String SERVICES = "services";
    String CHARACTERISTICS = "characteristics";
    String CHARACTERISTICS_FOR_SERVICE = "characteristicsForService";
}
