package com.polidea.flutter_ble_lib.converter;

import android.util.Log;

import com.polidea.multiplatformbleadapter.Device;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import androidx.annotation.Nullable;

public class DevicesResultJsonConverter implements JsonConverter<Device[]> {

    public static String TAG = DevicesResultJsonConverter.class.getName();

    private interface Metadata {
        String ID = "id";
        String NAME = "name";
    }

    @Override
    @Nullable
    public String toJson(Device[] devices) throws JSONException {
        JSONArray jsonDevicesArray = new JSONArray();

        for (Device device : devices) {
            Log.d(TAG, "try to parse json " + device.toString());
            JSONObject jsonDevice = new JSONObject();
            jsonDevice.put(Metadata.ID, device.getId());
            jsonDevice.put(Metadata.NAME, device.getName());
            jsonDevicesArray.put(jsonDevice);
        }

        return jsonDevicesArray.toString();
    }
}