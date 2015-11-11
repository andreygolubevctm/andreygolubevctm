package com.ctm.web.core.services;

public enum Endpoint {

    QUOTE("quote"),
    APPLY("apply"),
    SUMMARY("summary");

    private final String value;

    Endpoint(final String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
