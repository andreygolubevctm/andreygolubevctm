package com.ctm.providers.health.healthapply.model.request.application.common;

import com.ctm.interfaces.common.types.ValueType;

public class FirstName extends ValueType<String> {

    private FirstName(final String value) {
        super(value);
    }

    public static FirstName instanceOf(final String value) {
        return new FirstName(value);
    }

}