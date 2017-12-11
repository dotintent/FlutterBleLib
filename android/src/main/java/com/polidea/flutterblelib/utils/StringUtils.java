package com.polidea.flutterblelib.utils;


public class StringUtils {

    private static final String EMPTY = "";

    public String safeNullInstance(String string) {
        if (string == null) {
            return EMPTY;
        }
        return string;
    }
}
