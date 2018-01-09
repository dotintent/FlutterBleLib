package com.polidea.flutterblelib.wrapper;


import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class Service {


    private Device device;
    private BluetoothGattService service;
    private String id;

    public Service(@NonNull Device device, @NonNull BluetoothGattService service) {
        this.device = device;
        this.service = service;
        this.id = UUID.randomUUID().toString();
    }

    public String getId() {
        return id;
    }

    public Device getDevice() {
        return device;
    }

    public BluetoothGattService getNativeService() {
        return service;
    }

    @Nullable
    public Characteristic getCharacteristicByUUID(@NonNull UUID uuid) {
        BluetoothGattCharacteristic characteristic = service.getCharacteristic(uuid);
        if (characteristic == null) return null;
        return new Characteristic(this, characteristic);
    }

    public List<Characteristic> getCharacteristics() {
        ArrayList<Characteristic> characteristics = new ArrayList<>(service.getCharacteristics().size());
        for (BluetoothGattCharacteristic gattCharacteristic : service.getCharacteristics()) {
            characteristics.add(new Characteristic(this, gattCharacteristic));
        }
        return characteristics;
    }
}
