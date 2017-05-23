package com.ctm.energy.product.response.model.types;

import com.ctm.interfaces.common.types.OptionalValueType;

public class PaymentDetails extends OptionalValueType<String> {

    private PaymentDetails(final String value) {
        super(value);
    }

    private PaymentDetails() {
        super();
    }

    public static PaymentDetails instanceOf(final String value) {
        return new PaymentDetails(value);
    }

    public static PaymentDetails empty() {
        return new PaymentDetails();
    }

}