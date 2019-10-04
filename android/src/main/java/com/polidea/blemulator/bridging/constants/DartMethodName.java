package com.polidea.blemulator.bridging.constants;

public interface DartMethodName {
    String CREATE_CLIENT = "createClient";
    String DESTROY_CLIENT = "destroyClient";

    String START_DEVICE_SCAN = "startDeviceScan";
    String STOP_DEVICE_SCAN = "stopDeviceScan";

    String READ_CHARACTERISTIC_FOR_IDENTIFIER = "readCharacteristicForIdentifier";
    String READ_CHARACTERISTIC_FOR_DEVICE = "readCharacteristicForDevice";
    String READ_CHARACTERISTIC_FOR_SERVICE = "readCharacteristicForService";
}
