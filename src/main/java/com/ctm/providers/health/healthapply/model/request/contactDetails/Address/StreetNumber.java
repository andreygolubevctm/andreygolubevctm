package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

public class StreetNumber extends ValueType<String> {

    private StreetNumber(final String value) {
        super(value);
    }

    public static StreetNumber instanceOf(final String value) {
        return new StreetNumber(value);
    }

}