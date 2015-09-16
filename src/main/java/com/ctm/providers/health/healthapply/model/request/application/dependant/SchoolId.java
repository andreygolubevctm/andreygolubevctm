package com.ctm.providers.health.healthapply.model.request.application.dependant;

import com.ctm.interfaces.common.types.ValueType;

public class SchoolId extends ValueType<String> {

    private SchoolId(final String value) {
        super(value);
    }

    private SchoolId() {
        super("");
    }

    public static SchoolId instanceOf(final String value) {
        return new SchoolId(value);
    }

    public static SchoolId empty() {
        return new SchoolId();
    }

}