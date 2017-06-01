package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class PlanDetails extends OptionalValueType<String> {

    private PlanDetails(final String value) {
        super(value);
    }

    private PlanDetails() {
        super();
    }

    public static PlanDetails instanceOf(final String value) {
        return new PlanDetails(value);
    }

    public static PlanDetails empty() {
        return new PlanDetails();
    }

}