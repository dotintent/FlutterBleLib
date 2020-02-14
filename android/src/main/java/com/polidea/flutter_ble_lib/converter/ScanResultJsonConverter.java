package com.polidea.flutter_ble_lib.converter;

import com.polidea.multiplatformbleadapter.AdvertisementData;
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

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class ScanResultJsonConverter implements JsonConverter<ScanResult> {

    private interface Metadata {
        String ID = "id";
        String NAME = "name";
        String RSSI = "rssi";
        String MTU = "mtu";

        String MANUFACTURER_DATA = "manufacturerData";
        String SERVICE_DATA = "serviceData";
        String SERVICE_UUIDS = "serviceUUIDs";
        String LOCAL_NAME = "localName";
        String TX_POWER_LEVEL = "txPowerLevel";
        String SOLICITED_SERVICE_UUIDS = "solicitedServiceUUIDs";
        String IS_CONNECTABLE = "isConnectable";
        String OVERFLOW_SERVICE_UUIDS = "overflowServiceUUIDs";
    }

    @Override
    @Nullable
    public String toJson(ScanResult value) {
        try {
            JSONObject root = new JSONObject();
            root.put(Metadata.ID, value.getDeviceId() != null ? value.getDeviceId() : JSONObject.NULL);
            root.put(Metadata.NAME, value.getDeviceName() != null ? value.getDeviceName() : JSONObject.NULL);
            root.put(Metadata.RSSI, value.getRssi());
            root.put(Metadata.MTU, value.getMtu());
            if (value.getAdvertisementData() != null) {
                serializeAdvertisementData(root, value.getAdvertisementData());
            }
            root.put(Metadata.IS_CONNECTABLE, JSONObject.NULL);
            root.put(Metadata.OVERFLOW_SERVICE_UUIDS, JSONObject.NULL);
            return root.toString();
        } catch (JSONException jsonException) {
            jsonException.printStackTrace();
            return null;
        }
    }

    private void serializeAdvertisementData(JSONObject root,
                                            @NonNull AdvertisementData advertisementData) throws JSONException {
        serializeManufacturerData(root, advertisementData);
        serializeServiceData(root, advertisementData);
        serializeServiceUuids(root, advertisementData);
        serializeSolicitedServiceUuids(root, advertisementData);
        root.put(Metadata.LOCAL_NAME, advertisementData.getLocalName() != null
                ? advertisementData.getLocalName() : JSONObject.NULL);
        root.put(Metadata.TX_POWER_LEVEL, advertisementData.getTxPowerLevel() != null
                ? advertisementData.getTxPowerLevel() : JSONObject.NULL);
    }

    private void serializeManufacturerData(JSONObject target,
                                           @NonNull AdvertisementData advertisementData) throws JSONException {
        target.put(Metadata.MANUFACTURER_DATA, advertisementData.getManufacturerData() != null ?
                Base64Converter.encode(advertisementData.getManufacturerData()) : JSONObject.NULL);
    }

    private void serializeServiceData(JSONObject target,
                                      @NonNull AdvertisementData advertisementData) throws JSONException {
        if (advertisementData.getServiceData() != null && !advertisementData.getServiceData().isEmpty()) {
            Map<String, String> serviceData = new HashMap<>();
            for (Map.Entry<UUID, byte[]> entry : advertisementData.getServiceData().entrySet()) {
                serviceData.put(UUIDConverter.fromUUID(entry.getKey()),
                        Base64Converter.encode(entry.getValue()));
            }
            target.put(Metadata.SERVICE_DATA, new JSONObject(serviceData));
        } else {
            target.put(Metadata.SERVICE_DATA, JSONObject.NULL);
        }
    }

    private void serializeServiceUuids(JSONObject target,
                                       @NonNull AdvertisementData advertisementData) throws JSONException {
        if (advertisementData.getServiceUUIDs() != null && !advertisementData.getServiceUUIDs().isEmpty()) {
            List<String> serviceUuids = new ArrayList<>();
            for (UUID uuid : advertisementData.getServiceUUIDs()) {
                serviceUuids.add(UUIDConverter.fromUUID(uuid));
            }
            target.put(Metadata.SERVICE_UUIDS, new JSONArray(serviceUuids));
        } else {
            target.put(Metadata.SERVICE_UUIDS, JSONObject.NULL);
        }
    }

    private void serializeSolicitedServiceUuids(JSONObject target,
                                                @NonNull AdvertisementData advertisementData) throws JSONException {
        if (advertisementData.getSolicitedServiceUUIDs() != null && !advertisementData.getSolicitedServiceUUIDs().isEmpty()) {
            List<String> solicitedServiceUuuids = new ArrayList<>();
            for (UUID uuid : advertisementData.getSolicitedServiceUUIDs()) {
                solicitedServiceUuuids.add(UUIDConverter.fromUUID(uuid));
            }
            target.put(Metadata.SOLICITED_SERVICE_UUIDS, new JSONArray(solicitedServiceUuuids));
        } else {
            target.put(Metadata.SOLICITED_SERVICE_UUIDS, JSONObject.NULL);
        }
    }
}