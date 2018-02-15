package com.polidea.flutterblelib;


import android.support.annotation.Nullable;
import android.util.Base64;

import com.google.protobuf.InvalidProtocolBufferException;
import com.polidea.flutterblelib.utils.StringUtils;
import com.polidea.flutterblelib.utils.UUIDConverter;
import com.polidea.flutterblelib.wrapper.Characteristic;
import com.polidea.flutterblelib.wrapper.Device;
import com.polidea.flutterblelib.wrapper.ScanSettingsWrapper;
import com.polidea.flutterblelib.wrapper.Service;
import com.polidea.rxandroidble.RxBleConnection;
import com.polidea.rxandroidble.RxBleDevice;
import com.polidea.rxandroidble.internal.RxBleLog;
import com.polidea.rxandroidble.scan.ScanResult;
import com.polidea.rxandroidble.scan.ScanSettings;

import java.util.List;


class Converter {

    private static final int NO_VALUE = -1;
    private static final String NO_STRING_VALUE = "";

    private final StringUtils stringUtils;

    Converter(StringUtils stringUtils) {
        this.stringUtils = stringUtils;
    }

    ScanSettingsWrapper convertToScanSettings(byte[] bytes) {
        try {
            BleData.ScanDataMessage scanDataMessage = BleData.ScanDataMessage
                    .newBuilder()
                    .mergeFrom(bytes)
                    .build();
            return convertToScanSettings(scanDataMessage);
        } catch (InvalidProtocolBufferException e) {
            return new ScanSettingsWrapper(new ScanSettings.Builder().build(), null);
        }
    }

    ScanSettingsWrapper convertToScanSettings(BleData.ScanDataMessage scanDataMessage) {
        final List<String> uuidList = scanDataMessage.getUuidsList();
        final String[] uuids = uuidList != null
                ? uuidList.toArray(new String[uuidList.size()])
                : null;
        return new ScanSettingsWrapper(
                new ScanSettings.Builder()
                .setScanMode(scanDataMessage.getScanMode())
                .setCallbackType(scanDataMessage.getCallbackType())
                .build(),
                uuids
        );
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
                .setId(stringUtils.safeNullInstance(device.getMacAddress()))
                .setName(stringUtils.safeNullInstance(device.getName()))
                .setMtu(mtu)
                .setRssi(rssi)
                .build();
    }

    BleData.ServiceMessage convertToBleServiceMessage(Service service) {
        final Device device = service.getDevice();
        return BleData.ServiceMessage.newBuilder()
                .setId(service.getId())
                .setDevice(convertToBleDeviceMessage(device))
                .setUuid(UUIDConverter.fromUUID(service.getUuid()))
                .setIsPrimary(service.isPrimary())
                .build();
    }

    BleData.CharacteristicMessage convertToBleCharacteristicMessage(Characteristic characteristic, byte[] value){
        final Service service = characteristic.getService();
        if (value == null) {
            value = characteristic.getValue();
        }
        return BleData.CharacteristicMessage.newBuilder()
                .setId(characteristic.getId())
                .setUuid(UUIDConverter.fromUUID(characteristic.getUUID()))
                .setServiceId(service.getId())
                .setServiceUuid(UUIDConverter.fromUUID(service.getUuid()))
                .setDeviceId(service.getDevice().getRxBleDevice().getMacAddress())
                .setIsReadable(characteristic.isReadable())
                .setIsWritableWithResponse(characteristic.isWritableWithResponse())
                .setIsWritableWithoutResponse(characteristic.isWritableWithoutResponse())
                .setIsNotificable(characteristic.isNotifiable())
                .setIsIndicatable(characteristic.isIndicatable())
                .setValue(value != null ?  Base64.encodeToString(value, Base64.NO_WRAP) : NO_STRING_VALUE)
                .build();

    }
}
