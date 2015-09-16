package com.ctm.providers.health.healthapply.model.request.contactDetails.Address;

import com.ctm.interfaces.common.types.ValueType;

public class FullAddressOneLine extends ValueType<String> {

    private FullAddressOneLine(final String value) {
        super(value);
    }

    public static FullAddressOneLine instanceOf(final String value) {
        return new FullAddressOneLine(value);
    }

}