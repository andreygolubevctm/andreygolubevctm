package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

public class Account {

    private final BankName bankName;

    private final BSB bsb;

    private final AccountName accountName;

    private final AccountNumber accountNumber;

    public Account(final BankName bankName, final BSB bsb, final AccountName accountName, final AccountNumber accountNumber) {
        this.bankName = bankName;
        this.bsb = bsb;
        this.accountName = accountName;
        this.accountNumber = accountNumber;
    }
}
