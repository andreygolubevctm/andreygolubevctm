package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.ctm.interfaces.common.types.ValueType;

public class BankName extends ValueType<String> {

    private BankName(final String value) {
        super(value);
    }

    public static BankName instanceOf(final String value) {
        return new BankName(value);
    }

}