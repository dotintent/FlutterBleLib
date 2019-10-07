package com.polidea.blemulator.bridging.decoder;

import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.utils.UUIDConverter;

import java.util.Map;
import java.util.UUID;

public class CharacteristicDartValueDecoder implements DartValueDecoder<Characteristic> {

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
        String IS_INDICATABLE = "isIndicatable";
        String VALUE = "value";
    }

    @Override
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
}