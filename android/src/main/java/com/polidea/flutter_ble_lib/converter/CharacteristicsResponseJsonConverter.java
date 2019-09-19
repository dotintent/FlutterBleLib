package com.polidea.flutter_ble_lib.converter;

import com.polidea.flutter_ble_lib.CharacteristicsResponse;
import com.polidea.multiplatformbleadapter.Characteristic;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CharacteristicsResponseJsonConverter implements JsonConverter<CharacteristicsResponse> {

    private interface Metadata {
        String UUID = "serviceUuid";
        String ID = "serviceId";
        String CHARACTERISTICS = "characteristics";
    }

    @Override
    public String toJson(CharacteristicsResponse characteristicsResponse) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.UUID, characteristicsResponse.getService().getUuid());
        jsonObject.put(Metadata.ID, characteristicsResponse.getService().getId());

        JSONArray jsonArray = new JSONArray();
        CharacteristicJsonConverter characteristicJsonConverter = new CharacteristicJsonConverter();
        for (Characteristic characteristic : characteristicsResponse.getCharacteristics()) {
            jsonArray.put(characteristicJsonConverter.toJson(characteristic));
        }

        jsonObject.put(Metadata.CHARACTERISTICS, jsonArray);
        return jsonObject.toString();
    }
}
