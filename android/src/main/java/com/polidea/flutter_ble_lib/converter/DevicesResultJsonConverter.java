package com.polidea.flutter_ble_lib.converter;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.polidea.multiplatformbleadapter.AdvertisementData;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.ScanResult;
import com.polidea.multiplatformbleadapter.utils.Base64Converter;
import com.polidea.multiplatformbleadapter.utils.UUIDConverter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class DevicesResultJsonConverter implements JsonConverter<Device[]> {

    public static String TAG = DevicesResultJsonConverter.class.getName();

    private interface Metadata {
        String ID = "id";
        String NAME = "name";
    }

    @Override
    @Nullable
    public String toJson(Device[] devices) {
        try {
            JSONArray jsonDevicesArray = new JSONArray();

            for (Device device : devices) {
                Log.d(TAG, "try to parse json " + device.toString());
                JSONObject jsonDevice = new JSONObject();
                jsonDevice.put(Metadata.ID, device.getId());
                jsonDevice.put(Metadata.NAME, device.getName());
                jsonDevicesArray.put(jsonDevice);
            }

            return jsonDevicesArray.toString();
        } catch (JSONException jsonException) {
            jsonException.printStackTrace();
            return null;
        }
    }
}