package com.polidea.flutter_ble_lib.converter;

import org.json.JSONException;

public interface JsonConverter<T> {

    String toJson(T value) throws JSONException;
}
