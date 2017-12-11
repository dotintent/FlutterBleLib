package com.polidea.flutterblelib.listener;


import com.polidea.flutterblelib.BleMethod;

public interface Namespace {
    String flutter_ble_lib = "flutter_ble_lib";
    String flutter_ble_lib_scanDevices = flutter_ble_lib + "/" + BleMethod.startDeviceScan;
}
