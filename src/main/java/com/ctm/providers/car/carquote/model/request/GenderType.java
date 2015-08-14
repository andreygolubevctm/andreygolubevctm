package com.ctm.providers.car.carquote.model.request;

import org.apache.commons.lang3.StringUtils;

public enum GenderType {

    MALE("M"),
    FEMALE("F");

    private String value;

    private GenderType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static GenderType fromValue(String value) {
        for (GenderType genderType : values()) {
            if (StringUtils.equals(genderType.value, value)) {
                return genderType;
            }
        }
        throw new IllegalArgumentException("GenderType [" +  value + "] doesn't match any values.");
    }
}
