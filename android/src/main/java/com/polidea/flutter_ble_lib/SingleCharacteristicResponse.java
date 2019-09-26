package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;

import java.util.UUID;

public class SingleCharacteristicResponse {
    private final Characteristic characteristic;
    private int serviceId;
    private UUID serviceUuid;

    public SingleCharacteristicResponse(Characteristic characteristics, int serviceId, UUID serviceUuid) {
        this.characteristic = characteristics;
        this.serviceId = serviceId;
        this.serviceUuid = serviceUuid;
    }

    public Characteristic getCharacteristic() {
        return characteristic;
    }

    public int getServiceId() {
        return serviceId;
    }

    public UUID getServiceUuid() {
        return serviceUuid;
    }
}
