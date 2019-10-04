package com.polidea.blemulator;

import com.polidea.multiplatformbleadapter.Characteristic;
import com.polidea.multiplatformbleadapter.Service;

import java.util.List;
import java.util.Map;

class DeviceContainer {
    private String identifier;
    private String name;
    private List<Service> services;
    private Map<String, List<Characteristic>> characteristics;

    DeviceContainer(String identifier, String name) {
        this.identifier = identifier;
        this.name = name;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    public Map<String, List<Characteristic>> getCharacteristics() {
        return characteristics;
    }

    public void setCharacteristics(Map<String, List<Characteristic>> characteristics) {
        this.characteristics = characteristics;
    }
}
