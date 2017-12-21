package com.polidea.flutterblelib.listener;


import com.polidea.flutterblelib.BleData;

public interface DeviceConnectionChangeListener extends OnSuccessAction<BleData.BleDeviceMessage> {

    DeviceConnectionChangeListener NULL = new DeviceConnectionChangeListener() {
        @Override
        public void onSuccess(BleData.BleDeviceMessage bleDeviceMessage) {

        }
    };
}
