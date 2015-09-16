package com.ctm.providers.health.healthapply.model.request.payment;


import com.ctm.providers.health.healthapply.model.request.payment.bank.Bank;
import com.ctm.providers.health.healthapply.model.request.payment.credit.CreditCard;
import com.ctm.providers.health.healthapply.model.request.payment.details.Details;
import com.ctm.providers.health.healthapply.model.request.payment.medicare.Medicare;

import java.util.Optional;

public class Payment {

    private Details details;

    private CreditCard creditCard;

    private Bank bank;

    private Medicare medicare;

    public Optional<Details> getDetails() {
        return Optional.ofNullable(details);
    }

    public Optional<CreditCard> getCreditCard() {
        return Optional.ofNullable(creditCard);
    }

    public Optional<Bank> getBank() {
        return Optional.ofNullable(bank);
    }

    public Optional<Medicare> getMedicare() {
        return Optional.ofNullable(medicare);
    }
}
