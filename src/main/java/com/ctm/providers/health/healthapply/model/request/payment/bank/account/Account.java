package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Account {

    @JsonSerialize(using = TypeSerializer.class)
    private final BankName bankName;

    @JsonSerialize(using = TypeSerializer.class)
    private final BSB bsb;

    @JsonSerialize(using = TypeSerializer.class)
    private final AccountName accountName;

    @JsonSerialize(using = TypeSerializer.class)
    private final AccountNumber accountNumber;

    public Account(final BankName bankName, final BSB bsb, final AccountName accountName, final AccountNumber accountNumber) {
        this.bankName = bankName;
        this.bsb = bsb;
        this.accountName = accountName;
        this.accountNumber = accountNumber;
    }
}
