package com.ctm.providers.health.healthapply.model.request.payment.bank.account;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class Account {

    private BankName bankName;

    private BSB bsb;

    private AccountName accountName;

    private AccountNumber accountNumber;

    public Optional<BankName> getBankName() {
        return Optional.ofNullable(bankName);
    }

    public Optional<BSB> getBsb() {
        return Optional.ofNullable(bsb);
    }

    public Optional<AccountName> getAccountName() {
        return Optional.ofNullable(accountName);
    }

    public Optional<AccountNumber> getAccountNumber() {
        return Optional.ofNullable(accountNumber);
    }

    @JsonProperty("bankName")
    private String bankName() {
        return bankName == null ? null : bankName.get();
    }

    @JsonProperty("bsb")
    private String bsb() {
        return bsb == null ? null : bsb.get();
    }

    @JsonProperty("accountName")
    private String accountName() {
        return accountName == null ? null : accountName.get();
    }

    @JsonProperty("accountNumber")
    private String accountNumber() {
        return accountNumber == null ? null : accountNumber.get();
    }
}
