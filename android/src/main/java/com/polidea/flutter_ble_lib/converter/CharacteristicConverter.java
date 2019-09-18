package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Characteristic;

import org.json.JSONException;
import org.json.JSONObject;

public class CharacteristicConverter implements JsonConverter<Characteristic> {


    private interface _CharacteristicMetadata {
        String uuid = "characteristicUuid";
        String id = "id";
        String isReadable = "isReadable";
        String isWritableWithResponse = "isWritableWithResponse";
        String isWritableWithoutResponse = "isWritableWithoutResponse";
        String isNotifiable = "isNotifiable";
        String isIndicatable = "isIndicatable";
        String value = "value";
    }

    @Override
    public String toJson(Characteristic characteristic) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(_CharacteristicMetadata.uuid, characteristic.getUuid());
        jsonObject.put(_CharacteristicMetadata.id, characteristic.getId());
        jsonObject.put(_CharacteristicMetadata.isReadable, characteristic.isReadable());
        jsonObject.put(_CharacteristicMetadata.isWritableWithResponse, characteristic.isWritableWithResponse());
        jsonObject.put(_CharacteristicMetadata.isWritableWithoutResponse, characteristic.isWritableWithoutResponse());
        jsonObject.put(_CharacteristicMetadata.isNotifiable, characteristic.isNotifiable());
        jsonObject.put(_CharacteristicMetadata.isIndicatable, characteristic.isIndicatable());
        jsonObject.put(_CharacteristicMetadata.value, characteristic.getValue());

        return jsonObject.toString();
    }
}
