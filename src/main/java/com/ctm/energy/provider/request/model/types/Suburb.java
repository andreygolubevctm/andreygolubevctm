package com.ctm.energy.provider.request.model.types;

import com.ctm.interfaces.common.types.ValueType;

public final class Suburb extends ValueType<String> {

    private Suburb(final String value) {
        super(value);
    }

    public static Suburb instanceOf(final String value) {
        return new Suburb(value);
    }

}