package com.ctm.providers.health.healthapply.model.request.application.common;

import com.ctm.interfaces.common.types.ValueType;

public class LastName extends ValueType<String> {

    private LastName(final String value) {
        super(value);
    }

    public static LastName instanceOf(final String value) {
        return new LastName(value);
    }

}