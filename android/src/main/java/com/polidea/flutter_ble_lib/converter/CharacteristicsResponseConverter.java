package com.polidea.flutter_ble_lib.converter;

import com.polidea.flutter_ble_lib.CharacteristicsResponse;
import com.polidea.multiplatformbleadapter.Characteristic;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CharacteristicsResponseConverter implements JsonConverter<CharacteristicsResponse> {

    private interface Metadata {
        String uuid = "serviceUuid";
        String id = "id";
        String characteristics = "characteristics";
    }

    @Override
    public String toJson(CharacteristicsResponse characteristicsResponse) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.uuid, characteristicsResponse.getService().getUuid());
        jsonObject.put(Metadata.id, characteristicsResponse.getService().getId());

        JSONArray jsonArray = new JSONArray();
        CharacteristicConverter characteristicConverter = new CharacteristicConverter();
        for (Characteristic characteristic : characteristicsResponse.getCharacteristics()) {
            jsonArray.put(characteristicConverter.toJson(characteristic));
        }


        jsonObject.put(Metadata.characteristics, jsonArray);
        return jsonObject.toString();
    }
}
