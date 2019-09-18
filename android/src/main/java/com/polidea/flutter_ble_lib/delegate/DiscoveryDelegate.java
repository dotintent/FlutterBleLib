package com.polidea.flutter_ble_lib.delegate;

import android.support.annotation.NonNull;

import com.polidea.flutter_ble_lib.CharacteristicsResponse;
import com.polidea.flutter_ble_lib.SafeMainThreadResolver;
import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.converter.CharacteristicsResponseConverter;
import com.polidea.flutter_ble_lib.converter.ServiceConverter;
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

    public DiscoveryDelegate(BleAdapter adapter) {
        this.adapter = adapter;
    }

    @Override
    public boolean canHandle(MethodCall call) {
        switch (call.method) {
            case MethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS:
            case MethodName.CHARACTERISTICS:
            case MethodName.SERVICES:
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
            case MethodName.CHARACTERISTICS:
                characteristics(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        call.<String>argument(ArgumentKey.SERVICE_UUID),
                        result
                );
            case MethodName.SERVICES:
                services(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        result
                );
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
                        result.error(String.valueOf(error.errorCode.code), error.reason, null);
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

    private void characteristics(String deviceId, final String serviceUuid, final MethodChannel.Result result) {
        adapter.getServicesForDevice(deviceId,
                new OnSuccessCallback<Service[]>() {
                    @Override
                    public void onSuccess(final Service[] data) {
                        for (final Service service : data) {
                            if (service.getUuid().equals(UUID.fromString(serviceUuid))) {
                                adapter.getCharacteristicsForService(service.getId(),
                                        new OnSuccessCallback<Characteristic[]>() {
                                            @Override
                                            public void onSuccess(Characteristic[] data) {
                                                CharacteristicsResponse characteristicsResponse = new CharacteristicsResponse(data, service);
                                                try {
                                                    String json = new CharacteristicsResponseConverter().toJson(characteristicsResponse);
                                                    result.success(json);
                                                } catch (JSONException e) {
                                                    result.error(e.toString(), e.getMessage(), null);
                                                }
                                            }
                                        },
                                        new OnErrorCallback() {
                                            @Override
                                            public void onError(BleError error) {
                                                result.error(String.valueOf(error.errorCode.code), error.reason, null);
                                            }
                                        });
                                return;
                            }
                        }

                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, null);
                    }
                });
    }

    private void services(String deviceId, final MethodChannel.Result result) {
        adapter.getServicesForDevice(deviceId,
                new OnSuccessCallback<Service[]>() {
                    @Override
                    public void onSuccess(final Service[] data) {
                        ServiceConverter converter = new ServiceConverter();
                        JSONArray jsonArray = new JSONArray();
                        try {
                            for (Service service : data) {
                                jsonArray.put(converter.toJson(service));
                            }
                        } catch (JSONException e) {
                            result.error(e.toString(), e.getMessage(), null);
                            return;
                        }
                        result.success(jsonArray.toString());
                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, null);
                    }
                });
    }
}
