package com.ctm.web.core.services;

public enum Endpoint {

    QUOTE("quote"),
    APPLY("apply"),
    SUMMARY("summary"),
    PAYMENT_AUTHORISE("payment/authorise"),
    PAYMENT_REGISTER("payment/register"),
    PROVIDER("provider");

    private final String value;

    Endpoint(final String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
