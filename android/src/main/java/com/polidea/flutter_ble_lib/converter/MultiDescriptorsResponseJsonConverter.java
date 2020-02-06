package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Descriptor;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class MultiDescriptorsResponseJsonConverter implements JsonConverter<List<Descriptor>> {

    private DescriptorJsonConverter descriptorJsonConverter = new DescriptorJsonConverter();

    private interface Metadata {
        String SERVICE_UUID = "serviceUuid";
        String SERVICE_ID = "serviceId";
        String CHARACTERISTIC_UUID = "characteristicUuid";
        String CHARACTERISTIC_ID = "id";
        String DESCRIPTORS = "descriptors";
    }

    @Override
    public String toJson(List<Descriptor> descriptors) throws JSONException {
        JSONObject root = new JSONObject();
        JSONArray array = new JSONArray();
        if (descriptors.size() > 0) {
            root.put(Metadata.SERVICE_ID, descriptors.get(0).getServiceId());
            root.put(Metadata.SERVICE_UUID, descriptors.get(0).getServiceUuid());
            root.put(Metadata.CHARACTERISTIC_ID, descriptors.get(0).getCharacteristicId());
            root.put(Metadata.CHARACTERISTIC_UUID, descriptors.get(0).getCharacteristicUuid());

            for (Descriptor descriptor : descriptors) {
                array.put(descriptorJsonConverter.toJsonObject(descriptor));
            }

        }
        root.put(Metadata.DESCRIPTORS, array);

        return root.toString();
    }
}
