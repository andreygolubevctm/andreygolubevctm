package com.ctm.providers.health.healthapply.model.request.payment;


import com.ctm.providers.health.healthapply.model.request.payment.bank.Bank;
import com.ctm.providers.health.healthapply.model.request.payment.credit.CreditCard;
import com.ctm.providers.health.healthapply.model.request.payment.details.Details;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Medicare;

public class Payment {

    private final Details details;

    private final CreditCard creditCard;

    private final Bank bank;

    private final Medicare medicare;

    private final Claims claims;

    public Payment(final Details details, final CreditCard creditCard, final Bank bank, final Medicare medicare, final Claims claims) {
        this.details = details;
        this.creditCard = creditCard;
        this.bank = bank;
        this.medicare = medicare;
        this.claims = claims;
    }
}
