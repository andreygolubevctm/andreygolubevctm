package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

public class Postcode extends ValueType<String> {

    private Postcode(final String value) {
        super(value);
    }

    public static Postcode instanceOf(final String value) {
        if(value == null || !value.matches("[0-9]{4}")) {
            throw new IllegalArgumentException("Invalid postcode: " + value);
        }
        return new Postcode(value);
    }

}