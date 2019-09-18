package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Service;

import org.json.JSONException;
import org.json.JSONObject;

public class ServiceConverter implements JsonConverter<Service> {

    private interface Metadata {
        String uuid = "serviceUuid";
        String id = "id";
    }

    @Override
    public String toJson(Service service) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.id, service.getId());
        jsonObject.put(Metadata.uuid, service.getUuid());

        return jsonObject.toString();
    }
}
