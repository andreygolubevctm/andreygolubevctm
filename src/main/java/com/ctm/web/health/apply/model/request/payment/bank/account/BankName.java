package com.ctm.web.health.apply.model.request.payment.bank.account;

import java.util.function.Supplier;

public class BankName implements Supplier<String> {

    private final String bankName;

    public BankName(final String bankName) {
        this.bankName = bankName;
    }

    @Override
    public String get() {
        return bankName;
    }
}