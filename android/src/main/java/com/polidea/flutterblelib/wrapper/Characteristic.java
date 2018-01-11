package com.polidea.flutterblelib.wrapper;


import android.bluetooth.BluetoothGattCharacteristic;
import android.support.annotation.NonNull;

import com.polidea.flutterblelib.utils.IdGenerator;
import com.polidea.flutterblelib.utils.IdGeneratorKey;
import com.polidea.rxandroidble.internal.RxBleLog;

import java.util.UUID;

public class Characteristic {

    public static final UUID CLIENT_CHARACTERISTIC_CONFIG_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");

    private Service service;
    private BluetoothGattCharacteristic characteristic;
    private int id;

    public Characteristic(@NonNull Service service, @NonNull BluetoothGattCharacteristic characteristic) {
        this.service = service;
        this.characteristic = characteristic;
        this.id = IdGenerator.getIdForKey(new IdGeneratorKey(service.getDevice().getRxBleDevice(), characteristic.getUuid(), characteristic.getInstanceId()));
    }

    public int getId() {
        return this.id;
    }

    public Service getService() {
        return service;
    }

    public BluetoothGattCharacteristic getNativeCharacteristic() {
        return characteristic;
    }

    private final static char[] hexArray = "0123456789ABCDEF".toCharArray();

    private static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public void logValue(String message, byte[] value) {
        if (value == null) {
            value = characteristic.getValue();
        }
        String hexValue = value != null ? bytesToHex(value) : "(null)";
        RxBleLog.v(message +
                " Characteristic(uuid: " + characteristic.getUuid().toString() +
                ", id: " + id +
                ", value: " + hexValue + ")");
    }
}