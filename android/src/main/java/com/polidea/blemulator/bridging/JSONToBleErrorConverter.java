package com.polidea.blemulator.bridging;

import com.polidea.multiplatformbleadapter.errors.BleError;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import org.json.JSONException;
import org.json.JSONObject;

public class JSONToBleErrorConverter {
    private static final String ERROR_CODE = "errorCode";
    private static final String REASON = "reason";

    public BleError bleErrorFromJSON(String jsonString) {
        try {
            JSONObject jsonObject = new JSONObject(jsonString);
            return new BleError(findValue(jsonObject.getInt(ERROR_CODE)), jsonObject.getString(REASON), -1);
        } catch (JSONException e) {
            return new BleError(BleErrorCode.UnknownError, "Failed to convert: " + jsonString, -1);
        }
    }

    private BleErrorCode findValue(int errorCode) throws JSONException {
        for (BleErrorCode value : BleErrorCode.values()) {
            if (value.code == errorCode) {
                return value;
            }
        }

        throw new JSONException("Failed to find value for " + errorCode);
    }
}
