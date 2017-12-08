package com.polidea.flutterblelib;


import android.support.annotation.Nullable;

import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.scan.ScanResult;

import java.util.HashMap;

public class BleDeviceContainer extends HashMap<String, ScanResult> {
    public void register(ScanResult scanResult) {
        final RxBleDevice bleDevice = scanResult.getBleDevice();
        this.put(bleDevice.getMacAddress(), scanResult);
    }

    @Nullable
    public RxBleDevice getRxBleDevice(String macAddress) {
        final ScanResult scanResult = get(macAddress);
        return scanResult != null ? scanResult.getBleDevice() : null;
    }
}
