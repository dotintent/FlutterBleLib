package com.polidea.flutterblelib.listener;


import com.polidea.flutterblelib.BleData;

public interface BluetoothStateChangeListener extends OnSuccessAction<BleData.BluetoothStateMessage> {

    BluetoothStateChangeListener NULL = new BluetoothStateChangeListener() {
        @Override
        public void onSuccess(BleData.BluetoothStateMessage bluetoothStateMessage) {

        }
    };
}
