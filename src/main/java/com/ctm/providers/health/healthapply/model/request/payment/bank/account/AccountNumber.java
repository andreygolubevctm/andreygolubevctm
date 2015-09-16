package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.ctm.interfaces.common.types.ValueType;

public class AccountNumber extends ValueType<String> {

    private AccountNumber(final String value) {
        super(value);
    }

    public static AccountNumber instanceOf(final String value) {
        return new AccountNumber(value);
    }

}