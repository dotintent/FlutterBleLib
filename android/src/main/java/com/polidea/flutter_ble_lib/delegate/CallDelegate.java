package com.polidea.flutter_ble_lib.delegate;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

abstract public class CallDelegate implements MethodChannel.MethodCallHandler {

    final List<String> supportedMethods;

    CallDelegate(List<String> supportedMethods) {
        this.supportedMethods = supportedMethods;
    }

    public boolean canHandle(MethodCall call) {
        return supportedMethods.contains(call.method);
    }
}
