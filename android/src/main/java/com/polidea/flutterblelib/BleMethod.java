package com.polidea.flutterblelib;


public interface BleMethod {

    String createClient = "createClient";
    String destroyClient = "destroyClient";
    String setLogLevel = "setLogLevel";
    String cancelTransaction = "cancelTransaction";
    String logLevel = "logLevel";
    String state = "state";
    String startDeviceScan = "startDeviceScan";
    String stopDeviceScan = "stopDeviceScan";
    String requestMTUForDevice = "requestMTUForDevice";
    String readRSSIForDevice = "readRSSIForDevice";
    String connectToDevice = "connectToDevice";
    String cancelDeviceConnection = "cancelDeviceConnection";
    String isDeviceConnected = "isDeviceConnected";
    String discoverAllServicesAndCharacteristicsForDevice = "discoverAllServicesAndCharacteristicsForDevice";
    String servicesForDevice = "servicesForDevice";
    String characteristicsForDevice = "characteristicsForDevice";
    String characteristicsForService = "characteristicsForService";
    String writeCharacteristicForDevice = "writeCharacteristicForDevice";
    String writeCharacteristicForService = "writeCharacteristicForService";
    String writeCharacteristic = "writeCharacteristic";
    String readCharacteristicForDevice = "readCharacteristicForDevice";
    String readCharacteristicForService = "readCharacteristicForService";
    String readCharacteristic = "readCharacteristic";
    String monitorCharacteristicForDevice = "monitorCharacteristicForDevice";
    String monitorCharacteristicForService = "monitorCharacteristicForService";
    String monitorCharacteristic = "monitorCharacteristic";
}
