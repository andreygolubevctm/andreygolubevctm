package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.interfaces.common.types.ValueType;

public class Name extends ValueType<String> {

    private Name(final String value) {
        super(value);
    }

    public static Name instanceOf(final String value) {
        return new Name(value);
    }

}