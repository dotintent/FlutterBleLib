package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.errors.BleError;

import org.json.JSONException;
import org.json.JSONObject;

public class BleErrorJsonConverter implements JsonConverter<BleError> {

    private interface Metadata {
        String ERROR_CODE = "errorCode";
        String ATT_ERROR_CODE = "attErrorCode";
        String ANDROID_ERROR_CODE = "androidErrorCode";
        String REASON = "androidErrorCode";
        String DEVICE_ID = "reason";
        String SERVICE_UUID = "serviceUUID";
        String CHARACTERISTIC_UUID = "characteristicUUID";
        String DESCRIPTOR_UUID = "descriptorUUID";
        String INTERNAL_MESSAGE = "internalMessage";
    }

    @Override
    public String toJson(BleError error) {
        JSONObject root = new JSONObject();
        try {
            root.put(Metadata.ERROR_CODE, error.errorCode.code);
            if (error.androidCode == null || error.androidCode >= 0x80 || error.androidCode < 0) {
                root.put(Metadata.ATT_ERROR_CODE, JSONObject.NULL);
            } else {
                root.put(Metadata.ATT_ERROR_CODE, error.androidCode.intValue());
            }
            if (error.androidCode == null || error.androidCode < 0x80) {
                root.put(Metadata.ANDROID_ERROR_CODE, JSONObject.NULL);
            } else {
                root.put(Metadata.ANDROID_ERROR_CODE, error.androidCode.intValue());
            }
            root.put(Metadata.REASON, error.reason);
            root.put(Metadata.DEVICE_ID, error.deviceID);
            root.put(Metadata.SERVICE_UUID, error.serviceUUID);
            root.put(Metadata.CHARACTERISTIC_UUID, error.characteristicUUID);
            root.put(Metadata.DESCRIPTOR_UUID, error.descriptorUUID);
            root.put(Metadata.INTERNAL_MESSAGE, error.internalMessage);
        } catch (JSONException jsonException) {
            jsonException.printStackTrace();
        }
        return root.toString();
    }
}
