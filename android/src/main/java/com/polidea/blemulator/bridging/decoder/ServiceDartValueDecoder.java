package com.polidea.blemulator.bridging.decoder;

import android.bluetooth.BluetoothGattService;

import com.polidea.blemulator.bridging.constants.SimulationArgumentName;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.utils.UUIDConverter;

import java.util.Map;
import java.util.UUID;

public class ServiceDartValueDecoder {

    public Service decode(String deviceId, Map<String, Object> values) {
        int serviceId = (int) values.get(SimulationArgumentName.SERVICE_ID);
        UUID serviceUuid = UUIDConverter.convert((String) values.get(SimulationArgumentName.SERVICE_UUID));
        BluetoothGattService bluetoothGattService = new BluetoothGattService(serviceUuid, BluetoothGattService.SERVICE_TYPE_PRIMARY);
        return new Service(serviceId, deviceId, bluetoothGattService);
    }
}