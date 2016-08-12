package com.ctm.web.health.apply.v2.model.request.payment.bank.account;

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