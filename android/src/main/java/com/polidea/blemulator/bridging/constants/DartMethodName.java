package com.polidea.blemulator.bridging.constants;

public interface DartMethodName {
    String CREATE_CLIENT = "createClient";
    String DESTROY_CLIENT = "destroyClient";

    String START_DEVICE_SCAN = "startDeviceScan";
    String STOP_DEVICE_SCAN = "stopDeviceScan";

    String CONNECT_TO_DEVICE = "connectToDevice";
    String IS_DEVICE_CONNECTED = "isDeviceConnected";
    String DISCONNECT_OR_CANCEL_CONNECTION = "disconnectOrCancelConnection";

    String DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS = "discoverAllServicesAndCharacteristics";
    String GET_SERVICES = "services";
    String GET_CHARACTERISTICS = "characteristics";

    String READ_CHARACTERISTIC_FOR_IDENTIFIER = "readCharacteristicForIdentifier";
    String READ_CHARACTERISTIC_FOR_DEVICE = "readCharacteristicForDevice";
    String READ_CHARACTERISTIC_FOR_SERVICE = "readCharacteristicForService";
    String WRITE_CHARACTERISTIC_FOR_IDENTIFIER = "writeCharacteristicForIdentifier";
    String WRITE_CHARACTERISTIC_FOR_DEVICE = "writeCharacteristicForDevice";
    String WRITE_CHARACTERISTIC_FOR_SERVICE = "writeCharacteristicForService";
    String CANCEL_TRANSACTION = "cancelTransaction";
}
