package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.ctm.interfaces.common.types.ValueType;

public class ExpiryMonth extends ValueType<String> {

    private ExpiryMonth(final String value) {
        super(value);
    }

    public static ExpiryMonth instanceOf(final String value) {
        if(value == null ) {
            throw new IllegalArgumentException("Invalid month: null");
        }
        if(value.matches("^(0[1-9]|1[012])$")) {
            return new ExpiryMonth(value);
        }
        if(value.matches("^[1-9]$")) {
            return new ExpiryMonth("0" + value);
        }
        throw new IllegalArgumentException("Invalid month: " + value);
    }

}