package com.polidea.flutterblelib;


import android.support.annotation.Nullable;

import com.google.protobuf.InvalidProtocolBufferException;
import com.polidea.flutterblelib.utils.StringUtils;
import com.polidea.flutterblelib.wrapper.Device;
import com.polidea.rxandroidble.RxBleConnection;
import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.internal.RxBleLog;
import com.polidea.rxandroidble.scan.ScanResult;
import com.polidea.rxandroidble.scan.ScanSettings;

class Converter {

    private static final int NO_VALUE = -1;

    private final StringUtils stringUtils;

    Converter(StringUtils stringUtils) {
        this.stringUtils = stringUtils;
    }

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

    BleData.ScanResultMessage convertToScanResultMessage(ScanResult scanResult) {
        return BleData.ScanResultMessage.newBuilder()
                .setBleDeviceMessage(convertToBleDeviceMessage(scanResult.getBleDevice()))
                .setRssi(scanResult.getRssi())
                .setTimestampNanos(scanResult.getTimestampNanos())
                .setScanCallbackTypeMessage(scanResult.getCallbackType().ordinal())
                .build();
    }

    @Nullable
    BleData.ScanResultMessage convertToScanResultMessage(byte[] scanResultByte) {
        try {
            return BleData.ScanResultMessage.newBuilder().mergeFrom(scanResultByte).build();
        } catch (InvalidProtocolBufferException e) {
            return null;
        }
    }

    @Nullable
    BleData.ConnectToDeviceDataMessage convertToConnectToDeviceDataMessage(byte[] connectToDeviceDataMessageByte) {
        try {
            return BleData.ConnectToDeviceDataMessage.newBuilder().mergeFrom(connectToDeviceDataMessageByte).build();
        } catch (InvalidProtocolBufferException e) {
            return null;
        }

    }

    int convertLogLevelMessageToInt(BleData.LogLevelMessage logLevel) {
        switch (logLevel) {
            case VERBOSE:
                return RxBleLog.VERBOSE;
            case DEBUG:
                return RxBleLog.DEBUG;
            case INFO:
                return RxBleLog.INFO;
            case WARNING:
                return RxBleLog.WARN;
            case ERROR:
                return RxBleLog.ERROR;
            case NONE:
            case UNRECOGNIZED:
            default:
                return RxBleLog.NONE;
        }
    }

    BleData.LogLevelMessage convertIntToLogLevel(int logLevel) {
        switch (logLevel) {
            case RxBleLog.VERBOSE:
                return BleData.LogLevelMessage.VERBOSE;
            case RxBleLog.DEBUG:
                return BleData.LogLevelMessage.DEBUG;
            case RxBleLog.INFO:
                return BleData.LogLevelMessage.INFO;
            case RxBleLog.WARN:
                return BleData.LogLevelMessage.WARNING;
            case RxBleLog.ERROR:
                return BleData.LogLevelMessage.ERROR;
            case RxBleLog.NONE:
                return BleData.LogLevelMessage.NONE;
            default:
                return BleData.LogLevelMessage.UNRECOGNIZED;
        }
    }

    BleData.RequestMtuTransactionMessage convertToMtuRequestTransactionMessage(byte[] mtuRequestTransactionMessage) {
        try {
            return BleData.RequestMtuTransactionMessage.parseFrom(mtuRequestTransactionMessage);
        } catch (InvalidProtocolBufferException e) {
            return null;
        }
    }

    BleData.BleDeviceMessage convertToBleDeviceMessage(Device device) {
        final RxBleDevice rxBleDevice = device.getRxBleDevice();
        if (rxBleDevice == null) {
            return null;
        }
        final RxBleConnection rxBleConnection = device.getConnection();
        if (rxBleConnection == null) {
            return convertToBleDeviceMessage(rxBleDevice, NO_VALUE, NO_VALUE);
        }
        return convertToBleDeviceMessage(rxBleDevice, rxBleConnection.getMtu(), NO_VALUE);

    }

    BleData.BleDeviceMessage convertToBleDeviceMessage(RxBleDevice rxBleDevice) {
        return convertToBleDeviceMessage(rxBleDevice, NO_VALUE, NO_VALUE);
    }

    BleData.BleDeviceMessage convertToBleDeviceMessage(RxBleDevice device, int mtu, int rssi) {
        return BleData.BleDeviceMessage.newBuilder()
                .setMacAddress(stringUtils.safeNullInstance(device.getMacAddress()))
                .setName(stringUtils.safeNullInstance(device.getName()))
                .setMtu(mtu)
                .setRssi(rssi)
                .build();
    }

    BleData.ReadRSSIForDeviceMessage convertToReadRSSIForDeviceMessage(byte[] readRSSIForDeviceMessageBytes) {
        try {
            return BleData.ReadRSSIForDeviceMessage.parseFrom(readRSSIForDeviceMessageBytes);
        } catch (InvalidProtocolBufferException e) {
            return null;
        }
    }
}
