package com.polidea.flutterblelib.utils;

import com.polidea.flutterblelib.listener.OnErrorAction;
import com.polidea.flutterblelib.listener.OnSuccessAction;

import java.util.concurrent.atomic.AtomicBoolean;

public class SafeAction<T> implements OnSuccessAction<T>, OnErrorAction {
    private OnSuccessAction<T> onSuccessAction;
    private OnErrorAction onErrorAction;
    private AtomicBoolean isFinished = new AtomicBoolean();

    public SafeAction(OnSuccessAction<T> onSuccessAction, OnErrorAction onErrorAction) {
        this.onSuccessAction = onSuccessAction;
        this.onErrorAction = onErrorAction;
    }

    @Override
    public void onError(Throwable t) {
        if (isFinished.compareAndSet(false, true)) {
            onErrorAction.onError(t);
        }
    }

    @Override
    public void onSuccess(T value) {
        if (isFinished.compareAndSet(false, true)) {
            onSuccessAction.onSuccess(value);
        }
    }
}
