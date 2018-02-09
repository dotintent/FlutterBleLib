package com.polidea.flutterblelib.wrapper;

import android.os.ParcelUuid;

import com.polidea.rxandroidble.scan.ScanFilter;
import com.polidea.rxandroidble.scan.ScanSettings;

public class ScanSettingsWrapper {
    private final ScanSettings scanSettings;
    private final  String[] uuids;

    public ScanSettingsWrapper(ScanSettings scanSettings, String[] uuids) {
        this.scanSettings = scanSettings;
        this.uuids = uuids;
    }

    public ScanSettings getScanSetting() {
        return scanSettings;
    }

    public ScanFilter[] getScanFilters() {
        if (uuids == null) {
            return null;
        }
        final ScanFilter [] scanFilters = new ScanFilter[uuids.length];
        for (int index = 0; index < uuids.length; index++) {
            scanFilters[index] = new ScanFilter.Builder().setServiceUuid(ParcelUuid.fromString(uuids[index])).build();
        }
        return scanFilters;
    }
}
