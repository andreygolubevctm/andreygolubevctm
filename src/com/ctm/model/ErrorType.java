package com.ctm.model;

public enum ErrorType {

    RETURNED_FAULT("returned_fault"),
    KNOCK_OUT("knock_out"),
    RETURNED_ERROR("returned_error"),
    INVALID("invalid"),
    UNKNOWN("unknown"),
    SERVICE_CALL_FAILED("service_call_failed");

    private final String value;

    private ErrorType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
