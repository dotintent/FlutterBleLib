package com.polidea.flutter_ble_lib.converter;


import com.polidea.flutter_ble_lib.ConnectionStateChange;

import org.json.JSONException;
import org.json.JSONObject;

import androidx.annotation.Nullable;

public class ConnectionStateChangeJsonConverter implements JsonConverter<ConnectionStateChange> {

    private interface Metadata {
        String PERIPHERAL_IDENTIFIER = "peripheralIdentifier";
        String CONNECTION_STATE = "connectionState";
    }

    @Nullable
    @Override
    public String toJson(ConnectionStateChange value) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.PERIPHERAL_IDENTIFIER, value.getPeripheralIdentifier());
        jsonObject.put(Metadata.CONNECTION_STATE, value.getConnectionState().value);

        return jsonObject.toString();
    }
}
