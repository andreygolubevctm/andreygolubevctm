package com.ctm.providers.health.healthapply.model.request.payment.medicare;

import com.ctm.interfaces.common.types.ValueType;

public class Position extends ValueType<Integer> {

    private Position(final Integer value) {
        super(value);
    }

    public static Position instanceOf(final Integer value) {
        return new Position(value);
    }

}