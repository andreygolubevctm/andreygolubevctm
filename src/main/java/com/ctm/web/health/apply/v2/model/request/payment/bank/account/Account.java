package com.ctm.web.health.apply.v2.model.request.payment.bank.account;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Account {

    @JsonSerialize(using = TypeSerializer.class)
    private final BankName bankName;

    @JsonSerialize(using = TypeSerializer.class)
    private final BSB bsb;

    @JsonSerialize(using = TypeSerializer.class)
    private final AccountName accountName;

    @JsonSerialize(using = TypeSerializer.class)
    private final AccountNumber accountNumber;

    public BankName getBankName() {
        return bankName;
    }

    public BSB getBsb() {
        return bsb;
    }

    public AccountName getAccountName() {
        return accountName;
    }

    public AccountNumber getAccountNumber() {
        return accountNumber;
    }

    public Account(final BankName bankName, final BSB bsb, final AccountName accountName, final AccountNumber accountNumber) {
        this.bankName = bankName;
        this.bsb = bsb;
        this.accountName = accountName;
        this.accountNumber = accountNumber;
    }
}
