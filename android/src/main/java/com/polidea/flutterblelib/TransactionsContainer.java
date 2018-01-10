package com.polidea.flutterblelib;


import com.polidea.flutterblelib.utils.DisposableMap;

import rx.Subscription;

public class TransactionsContainer {

    final private DisposableMap disposableMap = new DisposableMap();

    public void replaceTransactionSubscription(String key, Subscription subscription) {
        disposableMap.replaceSubscription(key, subscription);
    }

    public boolean removeTransactionSubscription(String key) {
        return disposableMap.removeSubscription(key);
    }

    public void clearTransactionsSubscription() {
        disposableMap.removeAllSubscriptions();
    }
}



