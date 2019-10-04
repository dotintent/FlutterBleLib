package com.polidea.blemulator;

public interface DiscoveryResponseParser {
    void parseDiscoveryResponse(String deviceIdentifier, Object response);
}
