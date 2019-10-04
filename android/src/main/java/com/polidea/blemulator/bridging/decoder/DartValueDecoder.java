package com.polidea.blemulator.bridging.decoder;

public interface DartValueDecoder<T> {

    public T decode(Object dartObject);
}
