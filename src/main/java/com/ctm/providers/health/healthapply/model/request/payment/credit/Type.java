package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.interfaces.common.types.ValueType;

public class Type extends ValueType<String> {

    private Type(final String value) {
        super(value);
    }

    public static Type instanceOf(final String value) {
        return new Type(value);
    }

}