package com.ctm.providers.health.healthapply.model.request.payment.bank;

import com.ctm.healthapply.model.request.payment.bank.account.Account;

import java.util.Optional;

public class Bank {

    private Account paymentAccount;

    private Account refundAccount;

    private Claims claims;

    public Optional<Account> getPaymentAccount() {
        return Optional.ofNullable(paymentAccount);
    }

    public Optional<Account> getRefundAccount() {
        return Optional.ofNullable(refundAccount);
    }

    public Optional<Claims> getClaims() {
        return Optional.ofNullable(claims);
    }
}
