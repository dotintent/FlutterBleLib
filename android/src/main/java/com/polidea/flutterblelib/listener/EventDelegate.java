package com.polidea.flutterblelib.listener;


import com.polidea.flutterblelib.Event;

public interface EventDelegate {
    <T> void dispatchEvent(Event event, T value);
}
