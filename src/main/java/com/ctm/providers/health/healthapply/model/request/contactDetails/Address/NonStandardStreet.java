package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

public class NonStandardStreet extends ValueType<String> {

    private NonStandardStreet(final String value) {
        super(value);
    }

    public static NonStandardStreet instanceOf(final String value) {
        return new NonStandardStreet(value);
    }

}