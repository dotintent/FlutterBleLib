package com.polidea.flutter_ble_lib.delegate;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public interface CallDelegate extends MethodChannel.MethodCallHandler {
    boolean canHandle(MethodCall call);
}
