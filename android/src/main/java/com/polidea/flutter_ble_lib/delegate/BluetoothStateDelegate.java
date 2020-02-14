package com.polidea.flutter_ble_lib.delegate;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.flutter_ble_lib.converter.BleErrorJsonConverter;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.errors.BleError;

import java.util.Arrays;
import java.util.List;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BluetoothStateDelegate extends CallDelegate {

    private static List<String> supportedMethods = Arrays.asList(
            MethodName.ENABLE_RADIO,
            MethodName.DISABLE_RADIO,
            MethodName.GET_STATE);

    private BleAdapter bleAdapter;
    private BleErrorJsonConverter bleErrorJsonConverter = new BleErrorJsonConverter();

    public BluetoothStateDelegate(BleAdapter bleAdapter) {
        super(supportedMethods);
        this.bleAdapter = bleAdapter;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case MethodName.ENABLE_RADIO:
                enableRadio(methodCall.<String>argument(ArgumentKey.TRANSACTION_ID), result);
                return;
            case MethodName.DISABLE_RADIO:
                disableRadio(methodCall.<String>argument(ArgumentKey.TRANSACTION_ID), result);
                return;
            case MethodName.GET_STATE:
                getState(result);
                return;
            default:
                throw new IllegalArgumentException(methodCall.method + " cannot be handle by this delegate");
        }
    }

    private void enableRadio(String transactionId, @NonNull final MethodChannel.Result result) {
        bleAdapter.enable(transactionId,
                new OnSuccessCallback<Void>() {
                    @Override
                    public void onSuccess(Void data) {
                        result.success(null);
                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
                    }
                });
    }

    private void disableRadio(String transactionId, @NonNull final MethodChannel.Result result) {
        bleAdapter.disable(transactionId,
                new OnSuccessCallback<Void>() {
                    @Override
                    public void onSuccess(Void data) {
                        result.success(null);
                    }
                }, new OnErrorCallback() {
                    @Override
                    public void onError(BleError error) {
                        result.error(String.valueOf(error.errorCode.code), error.reason, bleErrorJsonConverter.toJson(error));
                    }
                });
    }

    private void getState(@NonNull final MethodChannel.Result result) {
        result.success(bleAdapter.getCurrentState());
    }
}
