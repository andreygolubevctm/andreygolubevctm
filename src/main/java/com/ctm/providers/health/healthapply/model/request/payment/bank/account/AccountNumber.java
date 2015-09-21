package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import java.util.function.Supplier;

public class AccountNumber implements Supplier<String> {

    private final String accountNumber;

    public AccountNumber(final String accountNumber) {
        this.accountNumber = accountNumber;
    }

    @Override
    public String get() {
        return accountNumber;
    }
}