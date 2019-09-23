package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

import java.util.UUID;

public class MultiCharacteristicsResponse {
    private final Characteristic[] characteristics;
    private Service service;

    public MultiCharacteristicsResponse(Characteristic[] characteristics, Service service) {
        this.characteristics = characteristics;
        this.service = service;
    }

    public Characteristic[] getCharacteristics() {
        return characteristics;
    }

    public Service getService() {
        return service;
    }
}
