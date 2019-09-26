package com.polidea.blemulator.bridging;

import io.flutter.plugin.common.MethodChannel;

public class DartMethodCaller {
    private MethodChannel dartMethodChannel;

    public DartMethodCaller(MethodChannel dartMethodChannel) {
        this.dartMethodChannel = dartMethodChannel;
    }
}
