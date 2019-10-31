package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

public class CharacteristicsResponse {
    private final Characteristic[] characteristics;
    private final Service service;

    public CharacteristicsResponse(Characteristic[] characteristics, Service service) {
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
