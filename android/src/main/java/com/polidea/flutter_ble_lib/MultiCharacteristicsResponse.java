package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

import java.util.List;

public class MultiCharacteristicsResponse {
    private final List<Characteristic> characteristics;
    private Service service;

    public MultiCharacteristicsResponse(List<Characteristic> characteristics, Service service) {
        this.characteristics = characteristics;
        this.service = service;
    }

    public List<Characteristic> getCharacteristics() {
        return characteristics;
    }

    public Service getService() {
        return service;
    }
}
