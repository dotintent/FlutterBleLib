package com.polidea.flutterblelib;


import com.polidea.flutterblelib.utils.DisposableMap;

import rx.Subscription;

public class ConnectingDevicesContainer {

    final private DisposableMap disposableMap = new DisposableMap();

    public void replaceConnectingSubscription(String key, Subscription subscription) {
        disposableMap.replaceSubscription(key, subscription);
    }

    public boolean removeConnectigDeviceSubscription(String key) {
        return disposableMap.removeSubscription(key);
    }

    public void clearConnectigDeviceSubscription() {
        disposableMap.removeAllSubscriptions();
    }
}
