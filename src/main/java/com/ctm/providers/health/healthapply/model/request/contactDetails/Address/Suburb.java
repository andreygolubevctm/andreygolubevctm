package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

public class Suburb extends ValueType<String> {

    private Suburb(final String value) {
        super(value);
    }

    public static Suburb instanceOf(final String value) {
        return new Suburb(value);
    }

}