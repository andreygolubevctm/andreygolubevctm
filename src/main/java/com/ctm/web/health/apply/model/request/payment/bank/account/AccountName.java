package com.ctm.web.health.apply.model.request.payment.bank.account;

import java.util.function.Supplier;

public class AccountName implements Supplier<String> {

    private final String accountName;

    public AccountName(final String accountName) {
        this.accountName = accountName;
    }

    @Override
    public String get() {
        return accountName;
    }
}