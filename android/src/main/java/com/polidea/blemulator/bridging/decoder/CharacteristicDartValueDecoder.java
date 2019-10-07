package com.polidea.blemulator.bridging.decoder;

import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.utils.UUIDConverter;

import java.util.Map;
import java.util.UUID;

public class CharacteristicDartValueDecoder {

    private static UUID CLIENT_CHARACTERISTIC_CONFIG_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");

    private interface Metadata {
        String DEVICE_IDENTIFIER = "deviceIdentifier";
        String SERVICE_IDENTIFIER = "serviceId";
        String SERVICE_UUID = "serviceUuid";
        String UUID = "characteristicUuid";
        String ID = "characteristicId";
        String IS_READABLE = "isReadable";
        String IS_WRITABLE_WITH_RESPONSE = "isWritableWithResponse";
        String IS_WRITABLE_WITHOUT_RESPONSE = "isWritableWithoutResponse";
        String IS_NOTIFIABLE = "isNotifiable";
        String IS_NOTIFYING = "isNotifying";
        String IS_INDICATABLE = "isIndicatable";
        String VALUE = "value";
    }

    public Characteristic decode(Object dartObject) {
        Map<String, Object> values = (Map<String, Object>) dartObject;
        String deviceId = (String) values.get(Metadata.DEVICE_IDENTIFIER);
        UUID characteristicUuid = UUIDConverter.convert((String) values.get(Metadata.UUID));
//        int characteristicId = (Integer) values.get(Metadata.ID); TODO Pass this id to Characteristic constructor after merging with discovering feature
        int serviceId = (int) values.get(Metadata.SERVICE_IDENTIFIER);
        UUID serviceUuid = UUIDConverter.convert((String) values.get(Metadata.SERVICE_UUID));
        byte[] value = (byte[]) values.get(Metadata.VALUE);
        int properties = calculateProperties(values);

        BluetoothGattService bluetoothGattService = new BluetoothGattService(serviceUuid, 0);
        BluetoothGattCharacteristic bluetoothGattCharacteristic = new BluetoothGattCharacteristic(characteristicUuid, properties, 0);
        setNotifyingMode((Boolean) values.get(Metadata.IS_NOTIFYING), bluetoothGattCharacteristic);
        Service service = new Service(serviceId, deviceId, bluetoothGattService);
        Characteristic characteristic = new Characteristic(service, bluetoothGattCharacteristic);

        characteristic.setValue(value);
        return characteristic;
    }

    private int calculateProperties(Map<String, Object> dartValues) {
        boolean isReadable = (Boolean) dartValues.get(Metadata.IS_READABLE);
        boolean isWritableWithResponse = (Boolean) dartValues.get(Metadata.IS_WRITABLE_WITH_RESPONSE);
        boolean isWritableWithoutResponse = (Boolean) dartValues.get(Metadata.IS_WRITABLE_WITHOUT_RESPONSE);
        boolean isNotifiable = (Boolean) dartValues.get(Metadata.IS_NOTIFIABLE);
        boolean isIndicatable = (Boolean) dartValues.get(Metadata.IS_INDICATABLE);

        int properties = 0;
        if (isReadable) properties |= BluetoothGattCharacteristic.PROPERTY_READ;
        if (isWritableWithResponse) properties |= BluetoothGattCharacteristic.PROPERTY_WRITE;
        if (isWritableWithoutResponse)
            properties |= BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE;
        if (isNotifiable) properties |= BluetoothGattCharacteristic.PROPERTY_NOTIFY;
        if (isIndicatable) properties |= BluetoothGattCharacteristic.PROPERTY_INDICATE;
        return properties;
    }

    private void setNotifyingMode(boolean isNotifying, BluetoothGattCharacteristic characteristic) {
        BluetoothGattDescriptor descriptor = new BluetoothGattDescriptor(CLIENT_CHARACTERISTIC_CONFIG_UUID, 0);
        if (isNotifying) {
            descriptor.setValue(new byte[]{0x01});
        } else {
            descriptor.setValue(new byte[]{0x00});
        }
        characteristic.addDescriptor(descriptor);
    }
}