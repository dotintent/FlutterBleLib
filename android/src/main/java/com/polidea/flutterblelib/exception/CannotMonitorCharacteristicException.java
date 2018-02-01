package com.polidea.flutterblelib.exception;


import android.bluetooth.BluetoothGattCharacteristic;

public class CannotMonitorCharacteristicException extends RuntimeException {
    private BluetoothGattCharacteristic characteristic;

    public CannotMonitorCharacteristicException(BluetoothGattCharacteristic characteristic) {
        this.characteristic = characteristic;
    }

    public BluetoothGattCharacteristic getCharacteristic() {
        return characteristic;
    }
}