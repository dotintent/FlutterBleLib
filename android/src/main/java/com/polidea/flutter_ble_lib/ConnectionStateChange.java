package com.polidea.flutter_ble_lib;

import com.polidea.multiplatformbleadapter.ConnectionState;

public class ConnectionStateChange {
    private String peripheralIdentifier;
    private ConnectionState connectionState;

    public ConnectionStateChange(String peripheralIdentifier, ConnectionState connectionState) {
        this.peripheralIdentifier = peripheralIdentifier;
        this.connectionState = connectionState;
    }

    public String getPeripheralIdentifier() {
        return peripheralIdentifier;
    }

    public ConnectionState getConnectionState() {
        return connectionState;
    }
}
