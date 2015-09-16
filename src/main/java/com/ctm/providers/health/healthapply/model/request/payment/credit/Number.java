package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.interfaces.common.types.ValueType;

public class Number extends ValueType<String> {

    private Number(final String value) {
        super(value);
    }

    public static Number instanceOf(final String value) {
        return new Number(value);
    }

}