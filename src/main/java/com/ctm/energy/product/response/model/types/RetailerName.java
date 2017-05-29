package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class RetailerName extends OptionalValueType<String> {

    private RetailerName(final String value) {
        super(value);
    }

    private RetailerName() {
        super();
    }

    public static RetailerName instanceOf(final String value) {
        return new RetailerName(value);
    }

    public static RetailerName empty() {
        return new RetailerName();
    }

}