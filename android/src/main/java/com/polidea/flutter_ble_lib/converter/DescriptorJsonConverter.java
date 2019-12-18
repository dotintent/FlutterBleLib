package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.Descriptor;
import com.polidea.multiplatformbleadapter.utils.Base64Converter;

import org.json.JSONException;
import org.json.JSONObject;

public class DescriptorJsonConverter implements JsonConverter<Descriptor> {


    private interface Metadata {
        String SERVICE_UUID = "serviceUuid";
        String SERVICE_ID = "serviceId";
        String CHARACTERISTIC_UUID = "characteristicUuid";
        String CHARACTERISTIC_ID = "id";
        String DESCRIPTOR_UUID = "descriptorUuid";
        String DESCRIPTOR_ID = "descriptorId";
        String DESCRIPTOR_VALUE = "value";
    }

    @Override
    public String toJson(Descriptor descriptor) throws JSONException {
        JSONObject jsonObject = toJsonObject(descriptor);

        jsonObject.put(Metadata.SERVICE_ID, descriptor.getServiceId());
        jsonObject.put(Metadata.SERVICE_UUID, descriptor.getServiceUuid());
        jsonObject.put(Metadata.CHARACTERISTIC_ID, descriptor.getCharacteristicId());
        jsonObject.put(Metadata.CHARACTERISTIC_UUID, descriptor.getCharacteristicUuid());

        return jsonObject.toString();
    }

    public JSONObject toJsonObject(Descriptor descriptor) throws JSONException {
        JSONObject jsonObject = new JSONObject();


        jsonObject.put(Metadata.DESCRIPTOR_ID, descriptor.getId());
        jsonObject.put(Metadata.DESCRIPTOR_UUID, descriptor.getUuid());
        jsonObject.put(Metadata.DESCRIPTOR_VALUE,
                descriptor.getValue() != null ?
                        Base64Converter.encode(descriptor.getValue())
                        : JSONObject.NULL);

        return jsonObject;
    }
}
