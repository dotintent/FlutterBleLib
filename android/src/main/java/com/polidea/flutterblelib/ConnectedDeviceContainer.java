package com.polidea.flutterblelib;


import android.support.annotation.Nullable;

import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.scan.ScanResult;

import java.util.HashMap;

public class ConnectedDeviceContainer extends HashMap<String, BleData.ConnectedDeviceMessage> {

    public void register(BleData.ConnectedDeviceMessage connectedDeviceData) {
        this.put(connectedDeviceData.getDeviceMessage().getMacAddress(), connectedDeviceData);
    }

    @Nullable
    public BleData.ConnectedDeviceMessage getConnectedDeviceMessage(String macAddress) {
        return get(macAddress);
    }
}
