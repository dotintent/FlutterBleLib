package com.polidea.flutter_ble_lib.converter;


import com.polidea.multiplatformbleadapter.errors.BleError;

import org.json.JSONException;
import org.json.JSONObject;

import androidx.annotation.Nullable;

public class BleErrorJsonConverter implements JsonConverter<BleError> {

    public static final int MAX_ATT_ERROR = 0x80;

    private interface Metadata {
        String ERROR_CODE = "errorCode";
        String ATT_ERROR_CODE = "attErrorCode";
        String ANDROID_ERROR_CODE = "androidErrorCode";
        String REASON = "reason";
        String DEVICE_ID = "deviceID";
        String SERVICE_UUID = "serviceUUID";
        String CHARACTERISTIC_UUID = "characteristicUUID";
        String DESCRIPTOR_UUID = "descriptorUUID";
        String INTERNAL_MESSAGE = "internalMessage";
        String TRANSACTION_ID = "transactionId";
    }

    @Override
    @Nullable
    public String toJson(BleError error) {
        try {
            return toJsonObject(error).toString();
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Nullable
    public String toJson(BleError error, String transactionId) {
        try {
            JSONObject root = toJsonObject(error);
            root.put(Metadata.TRANSACTION_ID, transactionId != null ? transactionId : JSONObject.NULL);
            return root.toString();
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    private JSONObject toJsonObject(BleError error) throws JSONException {
        JSONObject root = new JSONObject();
        root.put(Metadata.ERROR_CODE, error.errorCode.code);
        if (error.androidCode == null || error.androidCode > MAX_ATT_ERROR || error.androidCode < 0) {
            root.put(Metadata.ATT_ERROR_CODE, JSONObject.NULL);
        } else {
            root.put(Metadata.ATT_ERROR_CODE, error.androidCode.intValue());
        }
        if (error.androidCode == null || error.androidCode <= MAX_ATT_ERROR) {
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
        return root;
    }
}