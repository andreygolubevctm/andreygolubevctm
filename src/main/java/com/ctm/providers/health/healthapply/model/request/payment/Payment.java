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

    public Payment(final Details details, final CreditCard creditCard, final Bank bank, final Medicare medicare) {
        this.details = details;
        this.creditCard = creditCard;
        this.bank = bank;
        this.medicare = medicare;
    }
}
