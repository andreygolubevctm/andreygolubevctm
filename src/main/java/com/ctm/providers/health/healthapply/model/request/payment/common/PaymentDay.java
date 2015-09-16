package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.ctm.healthapply.exception.InvalidApplicationException;
import com.ctm.interfaces.common.types.ValueType;

public class PaymentDay extends ValueType<Integer> {

    private PaymentDay(final Integer value) {
        super(value);
    }

    public static PaymentDay instanceOf(final Integer value) {
        if(value == null || value < 1 || value > 28) {
            throw new InvalidApplicationException("Invalid payment day: " + value);
        }
        return new PaymentDay(value);
    }

}