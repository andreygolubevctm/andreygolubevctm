package com.ctm.web.simples.phone.inin.model;

import com.ctm.interfaces.common.types.ValueType;

public final class Identity extends ValueType<String> {

    private Identity(final String value) {
        super(value);
    }

    public static Identity instanceOf(final String value) {
        return new Identity(value);
    }

}