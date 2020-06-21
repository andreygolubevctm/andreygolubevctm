package com.ctm.web.core.services;

import java.util.Objects;

public class Endpoint {

    public static final Endpoint QUOTE = Endpoint.instanceOf("quote");
    public static final Endpoint APPLY = Endpoint.instanceOf("apply");
    public static final Endpoint SUMMARY = Endpoint.instanceOf("summary");
    public static final Endpoint PAYMENT_AUTHORISE = Endpoint.instanceOf("payment/authorise");
    public static final Endpoint PAYMENT_REGISTER = Endpoint.instanceOf("payment/register");
    public static final Endpoint PROVIDER = Endpoint.instanceOf("provider");
    public static final Endpoint PRODUCT_INFO = Endpoint.instanceOf("product");
    public static final Endpoint VALIDATE = Endpoint.instanceOf("validate");
    public static final Endpoint POPULAR_DESTINATIONS = Endpoint.instanceOf("popularDestinations");
    public static final Endpoint ACTIVE_PROVIDER_CODES = Endpoint.instanceOf("activeProviderCodes");
    public static Endpoint instanceOf(String value) {
        return new Endpoint(value);
    }

    private final String value;

    private Endpoint(String value) {
        this.value = Objects.requireNonNull(value);
    }

    public String getValue() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Endpoint endpoint = (Endpoint) o;

        return value.equals(endpoint.value);

    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }

    @Override
    public String toString() {
        return value;
    }
}
