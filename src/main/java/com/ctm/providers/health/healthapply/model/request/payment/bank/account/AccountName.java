package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.ctm.interfaces.common.types.ValueType;

public class AccountName extends ValueType<String> {

    private AccountName(final String value) {
        super(value);
    }

    public static AccountName instanceOf(final String value) {
        return new AccountName(value);
    }

}