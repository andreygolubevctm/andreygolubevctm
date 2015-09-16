package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.interfaces.common.types.ValueType;

public class CCV extends ValueType<Integer> {

    private CCV(final Integer value) {
        super(value);
    }

    private CCV(final String value) {
        super(Integer.parseInt(value));
    }

    public static CCV instanceOf(final Integer value) {
        return new CCV(value);
    }

}