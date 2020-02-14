package com.polidea.flutter_ble_lib.delegate;

import android.util.Log;

import com.polidea.flutter_ble_lib.constant.ArgumentKey;
import com.polidea.flutter_ble_lib.constant.MethodName;
import com.polidea.multiplatformbleadapter.BleAdapter;
import com.polidea.multiplatformbleadapter.errors.BleErrorCode;

import java.util.Arrays;
import java.util.List;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LogLevelDelegate extends CallDelegate {

    private static final String TAG = LogLevelDelegate.class.getName();
    private static List<String> supportedMethods =  Arrays.asList(MethodName.LOG_LEVEL, MethodName.SET_LOG_LEVEL);

    private BleAdapter bleAdapter;

    public LogLevelDelegate(BleAdapter bleAdapter) {
        super(supportedMethods);
        this.bleAdapter = bleAdapter;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case MethodName.SET_LOG_LEVEL:
                setLogLevel(methodCall.<String>argument(ArgumentKey.LOG_LEVEL), result);
                return;
            case MethodName.LOG_LEVEL:
                logLevel(result);
                return;
            default:
                throw new IllegalArgumentException(methodCall.method + " cannot be handled by this delegate");
        }
    }

    private void logLevel(@NonNull final MethodChannel.Result result) {
        result.success(bleAdapter.getLogLevel().toUpperCase());
    }

    private void setLogLevel(@NonNull String logLevel, @NonNull final MethodChannel.Result result) {
        try {
            Log.d(TAG, "set log level to: " + logLevel);
            bleAdapter.setLogLevel(capitalizeFirstLetter(logLevel));
            result.success(null);
        } catch(Exception e) {
            Log.e(TAG, "setLogLevel error", e);
            result.error(String.valueOf(BleErrorCode.UnknownError), e.getMessage(), null);
        }
    }

    private String capitalizeFirstLetter(String text) {
        return text.length() == 0 ? text : text.substring(0, 1).toUpperCase() + text.substring(1);
    }
}
