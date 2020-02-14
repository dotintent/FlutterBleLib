package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

import java.util.List;
import java.util.UUID;

public class MultiCharacteristicsResponse {
    private final List<Characteristic> characteristics;
    private int serviceId;
    private UUID serviceUuid;

    public MultiCharacteristicsResponse(List<Characteristic> characteristics, Service service) {
        this.characteristics = characteristics;
        this.serviceId = service.getId();
        this.serviceUuid = service.getUuid();
    }

    public MultiCharacteristicsResponse(List<Characteristic> characteristics, int serviceId, UUID serviceUuid) {
        this.characteristics = characteristics;
        this.serviceId = serviceId;
        this.serviceUuid = serviceUuid;
    }

    public List<Characteristic> getCharacteristics() {
        return characteristics;
    }

    public int getServiceId() {
        return serviceId;
    }

    public UUID getServiceUuid() {
        return serviceUuid;
    }
}
