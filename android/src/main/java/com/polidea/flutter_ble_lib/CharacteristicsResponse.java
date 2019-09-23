package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

import java.util.UUID;

public class CharacteristicsResponse {
    private final Characteristic[] characteristics;
    private int serviceId;
    private UUID serviceUuid;

    public CharacteristicsResponse(Characteristic[] characteristics, int serviceId, UUID serviceUuid) {
        this.characteristics = characteristics;
        this.serviceId = serviceId;
        this.serviceUuid = serviceUuid;
    }

    public Characteristic[] getCharacteristics() {
        return characteristics;
    }

    public int getServiceId() {
        return serviceId;
    }

    public UUID getServiceUuid() {
        return serviceUuid;
    }
}
