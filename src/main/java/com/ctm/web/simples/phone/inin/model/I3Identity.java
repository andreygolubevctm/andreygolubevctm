package com.ctm.web.simples.phone.inin.model;

import com.ctm.interfaces.common.types.ValueType;

public final class I3Identity extends ValueType<String> {

    private I3Identity(final String value) {
        super(value);
    }

    public static I3Identity instanceOf(final String value) {
        return new I3Identity(value);
    }

}