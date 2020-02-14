package com.polidea.flutter_ble_lib.converter;

import com.polidea.flutter_ble_lib.MultiCharacteristicsResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MultiCharacteristicsResponseJsonConverter implements JsonConverter<MultiCharacteristicsResponse> {

    private interface Metadata {
        String UUID = "serviceUuid";
        String ID = "serviceId";
        String CHARACTERISTICS = "characteristics";
    }

    @Override
    public String toJson(MultiCharacteristicsResponse characteristicsResponse) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.UUID, characteristicsResponse.getServiceUuid());
        jsonObject.put(Metadata.ID, characteristicsResponse.getServiceId());

        JSONArray jsonArray = new CharacteristicJsonConverter().toJsonArray(characteristicsResponse.getCharacteristics());

        jsonObject.put(Metadata.CHARACTERISTICS, jsonArray);
        return jsonObject.toString();
    }
}
