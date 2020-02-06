package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Service;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class ServiceJsonConverter implements JsonConverter<Service> {

    private interface Metadata {
        String uuid = "serviceUuid";
        String id = "serviceId";
    }

    @Override
    public String toJson(Service service) throws JSONException {
        return toJsonObject(service).toString();
    }

    public String toJson(List<Service> services) throws JSONException {
        JSONArray array = new JSONArray();
        for (Service service : services) {
            array.put(toJsonObject(service));
        }

        return array.toString();
    }

    private JSONObject toJsonObject(Service service) throws JSONException {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put(Metadata.id, service.getId());
        jsonObject.put(Metadata.uuid, service.getUuid());

        return jsonObject;
    }
}
