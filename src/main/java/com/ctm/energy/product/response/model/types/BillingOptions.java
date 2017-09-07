package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class BillingOptions extends OptionalValueType<String> {

    private BillingOptions(final String value) {
        super(value);
    }

    private BillingOptions() {
        super();
    }

    public static BillingOptions instanceOf(final String value) {
        return new BillingOptions(value);
    }

    public static BillingOptions empty() {
        return new BillingOptions();
    }

}