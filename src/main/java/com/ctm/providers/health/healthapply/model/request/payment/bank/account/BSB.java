package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.ctm.interfaces.common.types.ValueType;

public class BSB extends ValueType<String> {

    private BSB(final String value) {
        super(value);
    }

    public static BSB instanceOf(final String value) {
        return new BSB(value);
    }

}