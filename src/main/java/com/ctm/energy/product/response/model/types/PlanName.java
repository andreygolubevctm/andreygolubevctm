package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class PlanName extends OptionalValueType<String> {

    private PlanName(final String value) {
        super(value);
    }

    private PlanName() {
        super();
    }

    public static PlanName instanceOf(final String value) {
        return new PlanName(value);
    }

    public static PlanName empty() {
        return new PlanName();
    }

}