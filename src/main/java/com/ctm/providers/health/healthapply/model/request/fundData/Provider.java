package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.interfaces.common.types.ValueType;

public class Provider extends ValueType<String> {

    private Provider(final String value) {
        super(value);
    }

    public static Provider instanceOf(final String value) {
        return new Provider(value);
    }

}