package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.ctm.interfaces.common.types.ValueType;

public class ExpiryYear extends ValueType<String> {

    private ExpiryYear(final String value) {
        super(value);
    }

    public static ExpiryYear instanceOf(final String value) {
        if(value == null || !value.matches("^([0-9]{2})$")) {
            throw new IllegalArgumentException("Invalid year: " + value);
        }
        return new ExpiryYear(value);
    }

}