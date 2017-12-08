package com.polidea.flutterblelib;


import android.content.Context;

import com.polidea.flutterblelib.exception.RxBleDeviceNotFoundException;
import com.polidea.flutterblelib.listener.OnErrorAction;
import com.polidea.flutterblelib.listener.OnSuccessAction;
import com.polidea.rxandroidble.RxBleClient;
import com.polidea.rxandroidble.RxBleConnection;
import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.scan.ScanResult;

import rx.Subscription;
import rx.functions.Action1;

public class BleHelper {
    RxBleClient rxBleClient;

    Converter converter;

    Subscription scanDevicesSubscription;

    BleDeviceContainer bleDeviceContainer;

    BleHelper(Context context) {
        rxBleClient = RxBleClient.create(context);
        converter = new Converter();
        bleDeviceContainer = new BleDeviceContainer();
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
                                bleDeviceContainer.register(scanResult);
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


    public void connectDevice(BleData.ScanResultMessage scanResultMessage,
                              final OnSuccessAction<BleData.ScanResultMessage> success,
                              final OnErrorAction error) {

        final String macAddress = scanResultMessage.getBleDeviceMessage().getMacAddress();
        final RxBleDevice rxBleDevice = bleDeviceContainer.getRxBleDevice(macAddress);
        if (rxBleDevice == null) {
            error.onError(new RxBleDeviceNotFoundException("Not found device for mac address : " + macAddress));
            return;
        }
        rxBleDevice.establishConnection(false).subscribe(
                new Action1<RxBleConnection>() {
                    @Override
                    public void call(RxBleConnection rxBleConnection) {
                        success.onSuccess(null);
                    }
                },
                new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {
                        error.onError(null);
                    }
                }
        );
    }


}