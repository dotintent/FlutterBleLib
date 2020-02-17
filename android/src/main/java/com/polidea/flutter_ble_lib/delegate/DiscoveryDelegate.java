package com.polidea.flutter_ble_lib.delegate;

import com.polidea.flutter_ble_lib.MultiCharacteristicsResponse;
import com.polidea.flutter_ble_lib.SafeMainThreadResolver;
import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.converter.BleErrorJsonConverter;
import com.polidea.flutter_ble_lib.converter.CharacteristicJsonConverter;
import com.polidea.flutter_ble_lib.converter.MultiCharacteristicsResponseJsonConverter;
import com.polidea.flutter_ble_lib.converter.MultiDescriptorsResponseJsonConverter;
import com.polidea.flutter_ble_lib.converter.ServiceJsonConverter;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Descriptor;
import com.polidea.multiplatformbleadapter.Device;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.Service;
import com.polidea.multiplatformbleadapter.errors.BleError;

import org.json.JSONException;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DiscoveryDelegate extends CallDelegate {
    private BleAdapter adapter;
    private BleErrorJsonConverter bleErrorJsonConverter = new BleErrorJsonConverter();
    private CharacteristicJsonConverter characteristicJsonConverter = new CharacteristicJsonConverter();
    private ServiceJsonConverter serviceJsonConverter = new ServiceJsonConverter();
    private MultiCharacteristicsResponseJsonConverter multiCharacteristicsResponseJsonConverter = new MultiCharacteristicsResponseJsonConverter();
    private MultiDescriptorsResponseJsonConverter multiDescriptorsResponseJsonConverter = new MultiDescriptorsResponseJsonConverter();

    private static List<String> supportedMethods = Arrays.asList(
            MethodName.DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS,
            MethodName.GET_CHARACTERISTICS,
            MethodName.GET_SERVICES,
            MethodName.GET_CHARACTERISTICS_FOR_SERVICE,

            MethodName.GET_DESCRIPTORS_FOR_CHARACTERISTIC,
            MethodName.GET_DESCRIPTORS_FOR_SERVICE,
            MethodName.GET_DESCRIPTORS_FOR_DEVICE
    );

    public DiscoveryDelegate(BleAdapter adapter) {
        super(supportedMethods);
        this.adapter = adapter;
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
                getCharacteristicsForService(call.<Integer>argument(ArgumentKey.SERVICE_IDENTIFIER), result);
                return;
            case MethodName.GET_DESCRIPTORS_FOR_CHARACTERISTIC:
                getDescriptorsForCharacteristic(
                        call.<Integer>argument(ArgumentKey.CHARACTERISTIC_IDENTIFIER),
                        result
                );
                return;
            case MethodName.GET_DESCRIPTORS_FOR_SERVICE:
                getDescriptorsForService(
                        call.<Integer>argument(ArgumentKey.SERVICE_IDENTIFIER),
                        call.<String>argument(ArgumentKey.CHARACTERISTIC_UUID),
                        result
                );
                return;
            case MethodName.GET_DESCRIPTORS_FOR_DEVICE:
                getDescriptorsForDevice(
                        call.<String>argument(ArgumentKey.DEVICE_IDENTIFIER),
                        call.<String>argument(ArgumentKey.SERVICE_UUID),
                        call.<String>argument(ArgumentKey.CHARACTERISTIC_UUID),
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
                        failWithError(result, error);
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
        try {
            List<Characteristic> characteristics = adapter.getCharacteristicsForDevice(deviceId, serviceUuid);

            MultiCharacteristicsResponse characteristicsResponse;

            if (characteristics.size() == 0) {
                characteristicsResponse = new MultiCharacteristicsResponse(
                        characteristics,
                        -1,
                        null
                );
            } else {
                characteristicsResponse = new MultiCharacteristicsResponse(
                        characteristics,
                        characteristics.get(0).getServiceID(),
                        characteristics.get(0).getServiceUUID()
                );
            }

            String json = multiCharacteristicsResponseJsonConverter.toJson(characteristicsResponse);
            result.success(json);
        } catch (BleError error) {
            error.printStackTrace();
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void getServices(String deviceId, final MethodChannel.Result result) {
        try {
            List<Service> services = adapter.getServicesForDevice(deviceId);
            result.success(serviceJsonConverter.toJson(services));
        } catch (BleError error) {
            error.printStackTrace();
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void getCharacteristicsForService(Integer serviceId, final MethodChannel.Result result) {
        try {
            List<Characteristic> characteristics = adapter.getCharacteristicsForService(serviceId);
            result.success(characteristicJsonConverter.toJson(characteristics));
        } catch (BleError error) {
            error.printStackTrace();
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void getDescriptorsForCharacteristic(
            final int characteristicId,
            final MethodChannel.Result result) {
        try {
            List<Descriptor> descriptors = adapter.descriptorsForCharacteristic(characteristicId);
            result.success(multiDescriptorsResponseJsonConverter.toJson(descriptors));
        } catch (BleError error) {
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void getDescriptorsForService(
            final int serviceId,
            final String characteristicUuid,
            final MethodChannel.Result result) {
        try {
            List<Descriptor> descriptors = adapter.descriptorsForService(serviceId, characteristicUuid);
            result.success(multiDescriptorsResponseJsonConverter.toJson(descriptors));
        } catch (BleError error) {
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void getDescriptorsForDevice(final String deviceId,
                                         final String serviceUuid,
                                         final String characteristicUuid,
                                         final MethodChannel.Result result) {
        try {
            List<Descriptor> descriptors = adapter.descriptorsForDevice(deviceId, serviceUuid, characteristicUuid);
            result.success(multiDescriptorsResponseJsonConverter.toJson(descriptors));
        } catch (BleError error) {
            failWithError(result, error);
        } catch (JSONException e) {
            e.printStackTrace();
            result.error(null, e.getMessage(), null);
        }
    }

    private void failWithError(MethodChannel.Result result, BleError error) {
        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
    }
}