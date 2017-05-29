package com.ctm.energy.provider.response.model.types;

import com.ctm.interfaces.common.types.ValueType;

public final class ProviderName extends ValueType<String> {

    private ProviderName(final String value) {
        super(value);
    }

    public static ProviderName instanceOf(final String value) {
        return new ProviderName(value);
    }

}