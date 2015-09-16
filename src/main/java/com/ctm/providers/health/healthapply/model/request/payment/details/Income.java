package com.ctm.providers.health.healthapply.model.request.payment.details;

import com.ctm.interfaces.common.types.ValueType;

public class Income extends ValueType<Long> {

    private Income(final Long value) {
        super(value);
    }

    public static Income instanceOf(final Long value) {
        if(value == null || value < 0) {
            throw new IllegalArgumentException("Invalid Income: " + value);
        }
        return new Income(value);
    }

}