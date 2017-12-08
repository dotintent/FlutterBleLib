package com.polidea.flutterblelib;


import com.google.protobuf.InvalidProtocolBufferException;
import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.scan.ScanCallbackType;
import com.polidea.rxandroidble.scan.ScanResult;
import com.polidea.rxandroidble.scan.ScanSettings;

public class Converter {

    ScanSettings convertToScanSettings(byte[] bytes) {
        try {
            BleData.ScanSettingsMessage scanSettingsMessage = BleData.ScanSettingsMessage
                    .newBuilder()
                    .mergeFrom(bytes)
                    .build();
            return convertToScanSettings(scanSettingsMessage);
        } catch (InvalidProtocolBufferException e) {
            return new ScanSettings.Builder().build();
        }
    }

    ScanSettings convertToScanSettings(BleData.ScanSettingsMessage scanResultMessage) {
        return new ScanSettings.Builder()
                .setScanMode(scanResultMessage.getScanMode())
                .setCallbackType(scanResultMessage.getCallbackType())
                .build();
    }

    BleData.ScanResultMessage convertToScanResultDTO(ScanResult scanResult) {
        return BleData.ScanResultMessage.newBuilder()
                .setBleDeviceMessage(convertToBleDeviceMessage(scanResult.getBleDevice()))
                .setRssi(scanResult.getRssi())
                .setTimestampNanos(scanResult.getTimestampNanos())
                .setScanCallbackTypeMessage(scanResult.getCallbackType().ordinal())
                .build();
    }

    BleData.BleDeviceMessage convertToBleDeviceMessage(RxBleDevice rxBleDevice) {
        return BleData.BleDeviceMessage.newBuilder().setMacAddress(rxBleDevice.getMacAddress()).build();
    }
}
