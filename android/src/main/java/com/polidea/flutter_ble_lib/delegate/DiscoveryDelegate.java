package com.polidea.flutter_ble_lib.delegate;

import android.support.annotation.NonNull;

import com.polidea.flutter_ble_lib.CharacteristicsResponse;
import com.polidea.flutter_ble_lib.SafeMainThreadResolver;
import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.converter.BleErrorJsonConverter;
import com.polidea.flutter_ble_lib.converter.CharacteristicJsonConverter;
import com.polidea.flutter_ble_lib.converter.CharacteristicsResponseJsonConverter;
import com.polidea.flutter_ble_lib.converter.ServiceJsonConverter;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.errors.BleError;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DiscoveryDelegate implements CallDelegate {
    private BleAdapter adapter;
    private BleErrorJsonConverter bleErrorJsonConverter = new BleErrorJsonConverter();

    public DiscoveryDelegate(BleAdapter adapter) {
        this.adapter = adapter;
    }

    @Override
    public boolean canHandle(MethodCall call) {
        switch (call.method) {
            case MethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS:
            case MethodName.GET_CHARACTERISTICS:
            case MethodName.GET_SERVICES:
            case MethodName.GET_CHARACTERISTICS_FOR_SERVICE:
                return true;
        }
        return false;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case MethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS:
                discoverAllServicesAndCharacteristics(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        call.<String>argument(ArgumentKey.TRANSACTION_ID),
                        result);
                return;
            case MethodName.GET_CHARACTERISTICS:
                getCharacteristics(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        call.<String>argument(ArgumentKey.SERVICE_UUID),
                        result
                );
                return;
            case MethodName.GET_SERVICES:
                getServices(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        result
                );
                return;
            case MethodName.GET_CHARACTERISTICS_FOR_SERVICE:
                getCharacteristicsForService(call.<Integer>argument(ArgumentKey.SERVICE_ID), result);
                return;
            default:
                throw new IllegalArgumentException(call.method + " cannot be handled by this delegate");
        }
    }

    private void discoverAllServicesAndCharacteristics(String deviceId, String transactionId, final MethodChannel.Result result) {
        final SafeMainThreadResolver resolver = new SafeMainThreadResolver<>(
                new OnSuccessCallback<Object>() {
                    @Override
                    public void onSuccess(Object data) {
                        result.success(null);
                    }
                },
                new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
                    }
                });

        adapter.discoverAllServicesAndCharacteristicsForDevice(deviceId, transactionId,
                new OnSuccessCallback<Device>() {
                    @Override
                    public void onSuccess(Device data) {
                        resolver.onSuccess(null);
                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        resolver.onError(error);
                    }
                });
    }

    private void getCharacteristics(String deviceId, final String serviceUuid, final MethodChannel.Result result) {
        final OnErrorCallback errorCallback = new OnErrorCallback() {
            @Override
            public void onError(BleError error) {
                result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
            }
        };

        OnSuccessCallback<Service[]> serviceFetchSuccessCallback = new OnSuccessCallback<Service[]>() {
            @Override
            public void onSuccess(final Service[] data) {
                Service foundService = null;
                for (final Service service : data) {
                    if (service.getUuid().equals(UUID.fromString(serviceUuid))) {
                        foundService = service;
                        break;
                    }
                }

                if (foundService == null) {
                    result.error("UnknownServiceException", "Service not found", "Unknown service UUID " + serviceUuid);
                    return;
                }

                final Service finalService = foundService;

                adapter.getCharacteristicsForService(foundService.getId(),
                        new OnSuccessCallback<Characteristic[]>() {
                            @Override
                            public void onSuccess(Characteristic[] data) {
                                CharacteristicsResponse characteristicsResponse = new CharacteristicsResponse(data, finalService);
                                try {
                                    String json = new CharacteristicsResponseJsonConverter().toJson(characteristicsResponse);
                                    result.success(json);
                                } catch (JSONException e) {
                                    result.error(e.toString(), e.getMessage(), null);
                                }
                            }
                        },
                        errorCallback);
            }
        };

        adapter.getServicesForDevice(deviceId, serviceFetchSuccessCallback, errorCallback);
    }

    private void getServices(String deviceId, final MethodChannel.Result result) {
        adapter.getServicesForDevice(deviceId,
                new OnSuccessCallback<Service[]>() {
                    @Override
                    public void onSuccess(final Service[] data) {
                        try {
                            result.success(new ServiceJsonConverter().toJson(data));
                        } catch (JSONException e) {
                            result.error(e.toString(), e.getMessage(), null);
                        }
                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
                    }
                });
    }

    private void getCharacteristicsForService(Integer serviceId, final MethodChannel.Result result) {
        adapter.getCharacteristicsForService(serviceId,
                new OnSuccessCallback<Characteristic[]>() {
                    @Override
                    public void onSuccess(Characteristic[] data) {
                        try {
                            result.success(new CharacteristicJsonConverter().toJson(data));
                        } catch (JSONException e) {
                            result.error(e.toString(), e.getMessage(), null);
                        }
                    }
                },
                new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
                    }
                });
    }
}
