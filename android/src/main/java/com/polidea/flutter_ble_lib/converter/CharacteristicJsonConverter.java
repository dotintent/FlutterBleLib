package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Characteristic;

import org.json.JSONException;
import org.json.JSONObject;

public class CharacteristicJsonConverter implements JsonConverter<Characteristic> {

    private interface Metadata {
        String UUID = "characteristicUuid";
        String ID = "id";
        String IS_READABLE = "isReadable";
        String IS_WRITABLE_WITH_RESPONSE = "isWritableWithResponse";
        String IS_WRITABLE_WITHOUT_RESPONSE = "isWritableWithoutResponse";
        String IS_NOTIFIABLE = "isNotifiable";
        String IS_INDICATABLE = "isIndicatable";
        String VALUE = "value";
    }

    @Override
    public String toJson(Characteristic characteristic) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.UUID, characteristic.getUuid());
        jsonObject.put(Metadata.ID, characteristic.getId());
        jsonObject.put(Metadata.IS_READABLE, characteristic.isReadable());
        jsonObject.put(Metadata.IS_WRITABLE_WITH_RESPONSE, characteristic.isWritableWithResponse());
        jsonObject.put(Metadata.IS_WRITABLE_WITHOUT_RESPONSE, characteristic.isWritableWithoutResponse());
        jsonObject.put(Metadata.IS_NOTIFIABLE, characteristic.isNotifiable());
        jsonObject.put(Metadata.IS_INDICATABLE, characteristic.isIndicatable());
        jsonObject.put(Metadata.VALUE, characteristic.getValue());

        return jsonObject.toString();
    }
}
