package com.ctm.providers.health.healthapply.model.request.fundData;

import com.ctm.interfaces.common.types.ValueType;

public class FundCode extends ValueType<String> {

    private FundCode(final String value) {
        super(value);
    }

    public static FundCode instanceOf(final String value) {
        return new FundCode(value);
    }


}