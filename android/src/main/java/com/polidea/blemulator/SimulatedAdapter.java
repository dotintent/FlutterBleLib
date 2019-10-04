package com.polidea.blemulator;

import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.util.Log;

import com.polidea.blemulator.bridging.DartMethodCaller;
import com.polidea.blemulator.bridging.DartValueHandler;
import com.polidea.blemulator.bridging.constants.SimulationArgumentName;
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
import com.polidea.multiplatformbleadapter.utils.Constants;
import com.polidea.multiplatformbleadapter.utils.LogLevel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class SimulatedAdapter implements BleAdapter, DiscoveryResponseParser {

    private static final String TAG = SimulatedAdapter.class.getSimpleName();

    private HashMap<String, DeviceContainer> knownPeripherals = new HashMap<>();
    private DartMethodCaller dartMethodCaller;
    private DartValueHandler dartValueHandler;
    private String logLevel = Constants.BluetoothLogLevel.NONE;

    SimulatedAdapter(DartMethodCaller dartMethodCaller, DartValueHandler dartValueHandler) {
        this.dartMethodCaller = dartMethodCaller;
        this.dartValueHandler = dartValueHandler;
    }

    @Override
    public void createClient(String restoreStateIdentifier,
                             OnEventCallback<String> onAdapterStateChangeCallback,
                             OnEventCallback<Integer> onStateRestored) {
        onStateRestored.onEvent(null);
        dartMethodCaller.createClient();
        Log.i(TAG, "createClient");
    }

    @Override
    public void destroyClient() {
        dartMethodCaller.destroyClient();
        Log.i(TAG, "destroyClient");
    }

    @Override
    public void enable(String transactionId,
                       OnSuccessCallback<Void> onSuccessCallback,
                       OnErrorCallback onErrorCallback) {
        Log.i(TAG, "enable");
    }

    @Override
    public void disable(String transactionId,
                        OnSuccessCallback<Void> onSuccessCallback,
                        OnErrorCallback onErrorCallback) {
        Log.i(TAG, "disable");
    }

    @Override
    public String getCurrentState() {
        Log.i(TAG, "getCurrentState");
        return null;
    }

    @Override
    public void startDeviceScan(String[] filteredUUIDs,
                                int scanMode,
                                int callbackType,
                                final OnEventCallback<ScanResult> onEventCallback,
                                OnErrorCallback onErrorCallback) {
        Log.i(TAG, "startDeviceScan");

        OnEventCallback<ScanResult> resultCallback = new OnEventCallback<ScanResult>() {
            @Override
            public void onEvent(ScanResult data) {
                if (!knownPeripherals.containsKey(data.getDeviceId())) {
                    knownPeripherals.put(
                            data.getDeviceId(),
                            new DeviceContainer(data.getDeviceId(), data.getDeviceName())
                    );
                }

                onEventCallback.onEvent(data);
            }
        };

        dartValueHandler.setScanResultPublisher(resultCallback);
        dartMethodCaller.startDeviceScan();
    }

    @Override
    public void stopDeviceScan() {
        Log.i(TAG, "stopDeviceScan");
        dartMethodCaller.stopDeviceScan();
        dartValueHandler.setScanResultPublisher(null);
    }

    @Override
    public void requestConnectionPriorityForDevice(String deviceIdentifier,
                                                   int connectionPriority,
                                                   String transactionId,
                                                   OnSuccessCallback<Device> onSuccessCallback,
                                                   OnErrorCallback onErrorCallback) {
        Log.i(TAG, "requestConnectionPriorityForDevice");
    }

    @Override
    public void readRSSIForDevice(String deviceIdentifier,
                                  String transactionId,
                                  OnSuccessCallback<Device> onSuccessCallback,
                                  OnErrorCallback onErrorCallback) {
        Log.i(TAG, "readRSSIForDevice");
    }

    @Override
    public void requestMTUForDevice(String deviceIdentifier,
                                    int mtu, String transactionId,
                                    OnSuccessCallback<Device> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i(TAG, "requestMTUForDevice");
    }

    @Override
    public void getKnownDevices(String[] deviceIdentifiers,
                                OnSuccessCallback<Device[]> onSuccessCallback,
                                OnErrorCallback onErrorCallback) {
        Log.i(TAG, "getKnownDevices");
    }

    @Override
    public void getConnectedDevices(String[] serviceUUIDs,
                                    OnSuccessCallback<Device[]> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i(TAG, "getConnectedDevices");
    }

    @Override
    public void connectToDevice(String deviceIdentifier,
                                ConnectionOptions connectionOptions,
                                OnSuccessCallback<Device> onSuccessCallback,
                                OnEventCallback<ConnectionState> onConnectionStateChangedCallback,
                                OnErrorCallback onErrorCallback) {
        Log.i(TAG, "connectToDevice");

        dartValueHandler.addConnectionStatePublisher(deviceIdentifier, onConnectionStateChangedCallback);

        dartMethodCaller.connectToDevice(
                deviceIdentifier,
                knownPeripherals.get(deviceIdentifier).getName(),
                connectionOptions,
                onSuccessCallback,
                onErrorCallback
        );
    }

    @Override
    public void cancelDeviceConnection(String deviceIdentifier,
                                       OnSuccessCallback<Device> onSuccessCallback,
                                       OnErrorCallback onErrorCallback) {
        Log.i(TAG, "cancelDeviceConnection");
        dartMethodCaller.disconnectOrCancelConnection(
                deviceIdentifier,
                knownPeripherals.get(deviceIdentifier).getName(),
                onSuccessCallback,
                onErrorCallback);
    }

    @Override
    public void isDeviceConnected(String deviceIdentifier,
                                  OnSuccessCallback<Boolean> onSuccessCallback,
                                  OnErrorCallback onErrorCallback) {
        Log.i(TAG, "isDeviceConnected");
        dartMethodCaller.isDeviceConnected(deviceIdentifier, onSuccessCallback, onErrorCallback);
    }

    @Override
    public void discoverAllServicesAndCharacteristicsForDevice(
            String deviceIdentifier,
            String transactionId,
            OnSuccessCallback<Device> onSuccessCallback,
            OnErrorCallback onErrorCallback) {
        Log.i(TAG, "discoverAllServicesAndCharacteristicsForDevice");
        dartMethodCaller
                .discoverAllServicesAndCharacteristicsForDevice(
                        deviceIdentifier,
                        knownPeripherals.get(deviceIdentifier).getName(),
                        transactionId,
                        this,
                        onSuccessCallback,
                        onErrorCallback);
    }

    @Override
    public Service[] getServicesForDevice(String deviceIdentifier) throws BleError {
        Log.i(TAG, "discoverAllServicesAndCharacteristicsForDevice");
        //TODO if (knownPeripherals.get(deviceIdentifier)) throw
        return knownPeripherals
                .get(deviceIdentifier)
                .getServices()
                .toArray(new Service[0]);
    }

    @Override
    public Characteristic[] getCharacteristicsForDevice(String deviceIdentifier,
                                                        String serviceUUID) throws BleError {
        Log.i(TAG, "discoverAllServicesAndCharacteristicsForDevice");
        //TODO if (knownPeripherals.get(deviceIdentifier)) throw
        return knownPeripherals
                .get(deviceIdentifier)
                .getCharacteristics()
                .get(serviceUUID)
                .toArray(new Characteristic[0]);
    }

    @Override
    public Characteristic[] getCharacteristicsForService(int serviceIdentifier) throws BleError {
        Log.i(TAG, "discoverAllServicesAndCharacteristicsForDevice");
        //TODO if (knownPeripherals.get(deviceIdentifier)) throw
        for (DeviceContainer deviceContainer : knownPeripherals.values()) {
            for (Service service : deviceContainer.getServices()) {
                if (service.getId() == serviceIdentifier) {
                    return deviceContainer
                            .getCharacteristics()
                            .get(service.getUuid().toString().toUpperCase())
                            .toArray(new Characteristic[0]);
                }
            }
        }
        return null;
    }

    @Override
    public void readCharacteristicForDevice(String deviceIdentifier,
                                            String serviceUUID,
                                            String characteristicUUID,
                                            String transactionId,
                                            OnSuccessCallback<Characteristic> onSuccessCallback,
                                            OnErrorCallback onErrorCallback) {
        Log.i(TAG, "readCharacteristicForDevice");
    }

    @Override
    public void readCharacteristicForService(int serviceIdentifier,
                                             String characteristicUUID,
                                             String transactionId,
                                             OnSuccessCallback<Characteristic> onSuccessCallback,
                                             OnErrorCallback onErrorCallback) {
        Log.i(TAG, "readCharacteristicForService");
    }

    @Override
    public void readCharacteristic(int characteristicIdentifer,
                                   String transactionId,
                                   OnSuccessCallback<Characteristic> onSuccessCallback,
                                   OnErrorCallback onErrorCallback) {
        Log.i(TAG, "readCharacteristic");
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
        Log.i(TAG, "writeCharacteristicForDevice");
    }

    @Override
    public void writeCharacteristicForService(int serviceIdentifier,
                                              String characteristicUUID,
                                              String valueBase64,
                                              boolean withResponse,
                                              String transactionId,
                                              OnSuccessCallback<Characteristic> onSuccessCallback,
                                              OnErrorCallback onErrorCallback) {
        Log.i(TAG, "writeCharacteristicForService");
    }

    @Override
    public void writeCharacteristic(int characteristicIdentifier,
                                    String valueBase64,
                                    boolean withResponse,
                                    String transactionId,
                                    OnSuccessCallback<Characteristic> onSuccessCallback,
                                    OnErrorCallback onErrorCallback) {
        Log.i(TAG, "writeCharacteristic");
    }

    @Override
    public void monitorCharacteristicForDevice(String deviceIdentifier,
                                               String serviceUUID,
                                               String characteristicUUID,
                                               String transactionId,
                                               OnEventCallback<Characteristic> onEventCallback,
                                               OnErrorCallback onErrorCallback) {
        Log.i(TAG, "monitorCharacteristicForDevice");
    }

    @Override
    public void monitorCharacteristicForService(int serviceIdentifier,
                                                String characteristicUUID,
                                                String transactionId, OnEventCallback<Characteristic> onEventCallback,
                                                OnErrorCallback onErrorCallback) {
        Log.i(TAG, "monitorCharacteristicForService");
    }

    @Override
    public void monitorCharacteristic(int characteristicIdentifier,
                                      String transactionId,
                                      OnEventCallback<Characteristic> onEventCallback,
                                      OnErrorCallback onErrorCallback) {
        Log.i(TAG, "monitorCharacteristic");
    }

    @Override
    public void cancelTransaction(String transactionId) {
        Log.i(TAG, "cancelTransaction");
    }

    @Override
    public void setLogLevel(String logLevel) {
        Log.i(TAG, "setLogLevel");
        this.logLevel = logLevel;
    }

    @Override
    public String getLogLevel() {
        Log.i(TAG, "getLogLevel");
        return logLevel;
    }

    @Override
    public void parseDiscoveryResponse(String deviceIdentifier, Object responseObject) {
        List<Map<String, Object>> response = (List<Map<String, Object>>) responseObject;
        List<Service> services = new ArrayList<>();
        Map<String, List<Characteristic>> characteristics = new HashMap<>();
        for (Map<String, Object> mappedService : response) {
            Service service = new Service(
                    (Integer) mappedService.get(SimulationArgumentName.ID),
                    deviceIdentifier,
                    new BluetoothGattService(
                            UUID.fromString(
                                    (String) mappedService.get(SimulationArgumentName.UUID)
                            ),
                            BluetoothGattService.SERVICE_TYPE_PRIMARY
                    )
            );
            services.add(service);
            characteristics.put((String) mappedService.get(SimulationArgumentName.UUID),
                    parseCharacteristicsForServicesResponse(service,
                            (List<Map<String, Object>>) mappedService.get(SimulationArgumentName.CHARACTERISTICS)));
        }

        knownPeripherals.get(deviceIdentifier).setServices(services);
        knownPeripherals.get(deviceIdentifier).setCharacteristics(characteristics);
    }

    private List<Characteristic> parseCharacteristicsForServicesResponse(Service service, List<Map<String, Object>> response) {
        List<Characteristic> characteristics = new ArrayList<>();
        for (Map<String, Object> mappedCharacteristic : response) {
            characteristics.add(new Characteristic(
                    (Integer) mappedCharacteristic.get(SimulationArgumentName.ID),
                    service,
                    new BluetoothGattCharacteristic(
                            UUID.fromString(
                                    (String) mappedCharacteristic.get(SimulationArgumentName.UUID)
                            ), 0, 0 //TODO fix properties and permissions
                    )
            ));
        }
        return characteristics;
    }
}
