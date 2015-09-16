package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.interfaces.common.types.ValueType;

public class ExtrasCoverName extends ValueType<String> {

    private ExtrasCoverName(final String value) {
        super(value);
    }

    public static ExtrasCoverName instanceOf(final String value) {
        return new ExtrasCoverName(value);
    }

}