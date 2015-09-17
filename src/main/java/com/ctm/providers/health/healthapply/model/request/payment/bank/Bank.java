package com.ctm.providers.health.healthapply.model.request.payment.bank;

import com.ctm.providers.health.healthapply.model.request.payment.bank.account.Account;

public class Bank {

    private final Account paymentAccount;

    private final Account refundAccount;

    private final Claims claims;

    public Bank(final Account paymentAccount, final Account refundAccount, final Claims claims) {
        this.paymentAccount = paymentAccount;
        this.refundAccount = refundAccount;
        this.claims = claims;
    }
}
