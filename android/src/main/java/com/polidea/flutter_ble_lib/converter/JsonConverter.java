package com.polidea.flutter_ble_lib.converter;

import androidx.annotation.Nullable;

import org.json.JSONException;

public interface JsonConverter<T> {

    @Nullable
    String toJson(T value) throws JSONException;
}
