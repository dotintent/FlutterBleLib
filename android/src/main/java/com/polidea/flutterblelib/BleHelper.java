package com.polidea.flutterblelib;


import android.content.Context;

import com.polidea.flutterblelib.listener.OnErrorAction;
import com.polidea.flutterblelib.listener.OnSuccessAction;
import com.polidea.rxandroidble.RxBleClient;
import com.polidea.rxandroidble.scan.ScanResult;

import rx.Subscription;
import rx.functions.Action1;

public class BleHelper {
    RxBleClient rxBleClient;

    Converter converter;

    Subscription scanDevicesSubscription;

    BleHelper(Context context) {
        rxBleClient = RxBleClient.create(context);
        converter = new Converter();
    }

    void scanDevices(byte[] scanSettingsBytes,
                     final OnSuccessAction<BleData.ScanResultMessage> success,
                     final OnErrorAction error) {
        scanDevicesSubscription = rxBleClient
                .scanBleDevices(converter.convertToScanSettings(scanSettingsBytes))
                .subscribe(
                        new Action1<ScanResult>() {
                            @Override
                            public void call(ScanResult scanResult) {
                                success.onSuccess(converter.convertToScanResultDTO(scanResult));
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                error.onError(throwable);
                            }
                        }
                );
    }

    void stopScanDevices() {
        if (scanDevicesSubscription != null) {
            scanDevicesSubscription.unsubscribe();
            scanDevicesSubscription = null;
        }
    }
}