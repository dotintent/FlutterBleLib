package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.Characteristic;

import java.util.UUID;

public class SingleCharacteristicResponse {
    private final Characteristic characteristic;
    private int serviceId;
    private UUID serviceUuid;
    private String transactionId;

    public SingleCharacteristicResponse(Characteristic characteristics, int serviceId, UUID serviceUuid,
                                        String transactionId) {
        this.characteristic = characteristics;
        this.serviceId = serviceId;
        this.serviceUuid = serviceUuid;
        this.transactionId = transactionId;
    }

    public Characteristic getCharacteristic() {
        return characteristic;
    }

    public int getServiceId() {
        return serviceId;
    }

    public UUID getServiceUuid() {
        return serviceUuid;
    }

    public String getTransactionId() {
        return transactionId;
    }
}
