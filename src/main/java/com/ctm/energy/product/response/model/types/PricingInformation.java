package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class PricingInformation extends OptionalValueType<String> {

    private PricingInformation(final String value) {
        super(value);
    }

    private PricingInformation() {
        super();
    }

    public static PricingInformation instanceOf(final String value) {
        return new PricingInformation(value);
    }

    public static PricingInformation empty() {
        return new PricingInformation();
    }

}