package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.interfaces.common.types.ValueType;

public class School extends ValueType<String> {

    private School(final String value) {
        super(value);
    }

    public static School instanceOf(final String value) {
        return new School(value);
    }

}