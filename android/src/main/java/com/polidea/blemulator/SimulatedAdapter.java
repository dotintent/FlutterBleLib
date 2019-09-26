package com.polidea.blemulator;

import android.util.Log;

import com.polidea.blemulator.bridging.DartMethodCaller;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.ConnectionOptions;
import com.polidea.multiplatformbleadapter.ConnectionState;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnEventCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.ScanResult;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.errors.BleError;

public class SimulatedAdapter implements BleAdapter {

    private DartMethodCaller dartMethodCaller;

    SimulatedAdapter(DartMethodCaller dartMethodCaller) {
        this.dartMethodCaller = dartMethodCaller;
    }

    @Override
    public void createClient(String restoreStateIdentifier,
                             OnEventCallback<String> onAdapterStateChangeCallback,
                             OnEventCallback<Integer> onStateRestored) {
        Log.i("BLEMULATOR", "createClient");
    }

    @Override
    public void destroyClient() {
        Log.i("BLEMULATOR", "destroyClient");
    }

    @Override
    public void enable(String transactionId,
                       OnSuccessCallback<Void> onSuccessCallback,
                       OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "enable");
    }

    @Override
    public void disable(String transactionId,
                        OnSuccessCallback<Void> onSuccessCallback,
                        OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "disable");
    }

    @Override
    public String getCurrentState() {
        Log.i("BLEMULATOR", "getCurrentState");
        return null;
    }

    @Override
    public void startDeviceScan(String[] filteredUUIDs,
                                int scanMode,
                                int callbackType,
                                OnEventCallback<ScanResult> onEventCallback,
                                OnErrorCallback onErrorCallback) {
        Log.w("SIMULATOR", "startDeviceScan");
    }

    @Override
    public void stopDeviceScan() {
        Log.i("BLEMULATOR", "stopDeviceScan");
    }

    @Override
    public void requestConnectionPriorityForDevice(String deviceIdentifier,
                                                   int connectionPriority,
                                                   String transactionId,
                                                   OnSuccessCallback<Device> onSuccessCallback,
                                                   OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "requestConnectionPriorityForDevice");
    }

    @Override
    public void readRSSIForDevice(String deviceIdentifier,
                                  String transactionId,
                                  OnSuccessCallback<Device> onSuccessCallback,
                                  OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "readRSSIForDevice");
    }

    @Override
    public void requestMTUForDevice(String deviceIdentifier,
                                    int mtu, String transactionId,
                                    OnSuccessCallback<Device> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "requestMTUForDevice");
    }

    @Override
    public void getKnownDevices(String[] deviceIdentifiers,
                                OnSuccessCallback<Device[]> onSuccessCallback,
                                OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "getKnownDevices");
    }

    @Override
    public void getConnectedDevices(String[] serviceUUIDs,
                                    OnSuccessCallback<Device[]> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "getConnectedDevices");
    }

    @Override
    public void connectToDevice(String deviceIdentifier,
                                ConnectionOptions connectionOptions,
                                OnSuccessCallback<Device> onSuccessCallback,
                                OnEventCallback<ConnectionState> onConnectionStateChangedCallback,
                                OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "connectToDevice");
    }

    @Override
    public void cancelDeviceConnection(String deviceIdentifier,
                                       OnSuccessCallback<Device> onSuccessCallback,
                                       OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "cancelDeviceConnection");
    }

    @Override
    public void isDeviceConnected(String deviceIdentifier,
                                  OnSuccessCallback<Boolean> onSuccessCallback,
                                  OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "isDeviceConnected");
    }

    @Override
    public void discoverAllServicesAndCharacteristicsForDevice(
            String deviceIdentifier,
            String transactionId,
            OnSuccessCallback<Device> onSuccessCallback,
            OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "discoverAllServicesAndCharacteristicsForDevice");
    }

    @Override
    public Service[] getServicesForDevice(String deviceIdentifier) throws BleError {
        Log.i("BLEMULATOR", "discoverAllServicesAndCharacteristicsForDevice");
        return new Service[0];
    }

    @Override
    public Characteristic[] getCharacteristicsForDevice(String deviceIdentifier,
                                                        String serviceUUID) throws BleError {
        Log.i("BLEMULATOR", "discoverAllServicesAndCharacteristicsForDevice");
        return new Characteristic[0];
    }

    @Override
    public Characteristic[] getCharacteristicsForService(int serviceIdentifier) throws BleError {
        Log.i("BLEMULATOR", "discoverAllServicesAndCharacteristicsForDevice");
        return new Characteristic[0];
    }

    @Override
    public void readCharacteristicForDevice(String deviceIdentifier,
                                            String serviceUUID,
                                            String characteristicUUID,
                                            String transactionId,
                                            OnSuccessCallback<Characteristic> onSuccessCallback,
                                            OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "readCharacteristicForDevice");
    }

    @Override
    public void readCharacteristicForService(int serviceIdentifier,
                                             String characteristicUUID,
                                             String transactionId,
                                             OnSuccessCallback<Characteristic> onSuccessCallback,
                                             OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "readCharacteristicForService");
    }

    @Override
    public void readCharacteristic(int characteristicIdentifer,
                                   String transactionId,
                                   OnSuccessCallback<Characteristic> onSuccessCallback,
                                   OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "readCharacteristic");
    }

    @Override
    public void writeCharacteristicForDevice(String deviceIdentifier,
                                             String serviceUUID,
                                             String characteristicUUID,
                                             String valueBase64,
                                             boolean withResponse,
                                             String transactionId,
                                             OnSuccessCallback<Characteristic> onSuccessCallback,
                                             OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "writeCharacteristicForDevice");
    }

    @Override
    public void writeCharacteristicForService(int serviceIdentifier,
                                              String characteristicUUID,
                                              String valueBase64,
                                              boolean withResponse,
                                              String transactionId,
                                              OnSuccessCallback<Characteristic> onSuccessCallback,
                                              OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "writeCharacteristicForService");
    }

    @Override
    public void writeCharacteristic(int characteristicIdentifier,
                                    String valueBase64,
                                    boolean withResponse,
                                    String transactionId,
                                    OnSuccessCallback<Characteristic> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "writeCharacteristic");
    }

    @Override
    public void monitorCharacteristicForDevice(String deviceIdentifier,
                                               String serviceUUID,
                                               String characteristicUUID,
                                               String transactionId,
                                               OnEventCallback<Characteristic> onEventCallback,
                                               OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "monitorCharacteristicForDevice");
    }

    @Override
    public void monitorCharacteristicForService(int serviceIdentifier,
                                                String characteristicUUID,
                                                String transactionId, OnEventCallback<Characteristic> onEventCallback,
                                                OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "monitorCharacteristicForService");
    }

    @Override
    public void monitorCharacteristic(int characteristicIdentifier,
                                      String transactionId,
                                      OnEventCallback<Characteristic> onEventCallback,
                                      OnErrorCallback onErrorCallback) {
        Log.i("BLEMULATOR", "monitorCharacteristic");
    }

    @Override
    public void cancelTransaction(String transactionId) {
        Log.i("BLEMULATOR", "cancelTransaction");
    }

    @Override
    public void setLogLevel(String logLevel) {
        Log.i("BLEMULATOR", "setLogLevel");
    }

    @Override
    public String getLogLevel() {
        Log.i("BLEMULATOR", "getLogLevel");
        return null;
    }
}
