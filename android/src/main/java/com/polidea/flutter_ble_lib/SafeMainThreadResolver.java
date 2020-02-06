package com.polidea.flutter_ble_lib;

import android.os.Handler;
import android.os.Looper;

import com.polidea.multiplatformbleadapter.OnErrorCallback;
import com.polidea.multiplatformbleadapter.OnSuccessCallback;
import com.polidea.multiplatformbleadapter.errors.BleError;

import java.util.concurrent.atomic.AtomicBoolean;

public class SafeMainThreadResolver<T> implements OnSuccessCallback<T>, OnErrorCallback {

    private OnErrorCallback onErrorCallback = null;
    private OnSuccessCallback<T> onSuccessCallback = null;
    private AtomicBoolean called = new AtomicBoolean(false);

    public SafeMainThreadResolver(OnSuccessCallback<T> onSuccessCallback, OnErrorCallback onErrorCallback) {
        this.onErrorCallback = onErrorCallback;
        this.onSuccessCallback = onSuccessCallback;
    }

    public void onSuccess(final T data) {
        if (onSuccessCallback != null && called.compareAndSet(false, true)) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    onSuccessCallback.onSuccess(data);
                }
            });
        }
    }

    public void onError(final BleError error) {
        if (onErrorCallback != null && called.compareAndSet(false, true)) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    onErrorCallback.onError(error);
                }
            });
        }
    }
}
