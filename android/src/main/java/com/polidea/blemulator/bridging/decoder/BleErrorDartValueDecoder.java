package com.polidea.blemulator.bridging.decoder;

import com.polidea.multiplatformbleadapter.errors.BleError;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import java.util.Map;

public class BleErrorDartValueDecoder {

    private interface Metadata {
        String ERROR_CODE = "errorCode";
        String REASON = "reason";
    }

    public BleError decode(Map<String, Object> values) {
        return new BleError(
                mapToBleErrorCode((Integer) values.get(Metadata.ERROR_CODE)),
                (String) values.get(Metadata.REASON),
                null);
    }

    private BleErrorCode mapToBleErrorCode(int code) {
        for (BleErrorCode errorCode : BleErrorCode.values()) {
            if (errorCode.code == code) return errorCode;
        }
        return BleErrorCode.UnknownError;
    }
}
