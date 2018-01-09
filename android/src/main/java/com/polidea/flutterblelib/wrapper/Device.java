package com.polidea.flutterblelib.wrapper;


import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.polidea.flutterblelib.BleData;
import com.polidea.flutterblelib.utils.StringUtils;
import com.polidea.rxandroidble.RxBleConnection;
import com.polidea.rxandroidble.RxBleDevice;

import java.util.List;
import java.util.UUID;

public class Device {


    private RxBleDevice device;
    @Nullable
    private RxBleConnection connection;
    @Nullable
    private List<Service> services;

    public Device(@NonNull RxBleDevice device, @Nullable RxBleConnection connection) {
        this.device = device;
        this.connection = connection;
    }

    public void setServices(@NonNull List<Service> services) {
        this.services = services;
    }

    @Nullable
    public List<Service> getServices() {
        return services;
    }

    public RxBleDevice getRxBleDevice() {
        return device;
    }

    @Nullable
    public RxBleConnection getConnection() {
        return connection;
    }

    @Nullable
    public Service getServiceByUUID(@NonNull UUID uuid) {
        if (services == null) {
            return null;
        }

        for (Service service : services) {
            if (uuid.equals(service.getNativeService().getUuid()))
                return service;
        }
        return null;
    }
}