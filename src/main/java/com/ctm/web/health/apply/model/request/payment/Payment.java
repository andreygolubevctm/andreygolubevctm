package com.ctm.web.health.apply.model.request.payment;


import com.ctm.web.health.apply.model.request.payment.bank.Bank;
import com.ctm.web.health.apply.model.request.payment.credit.CreditCard;
import com.ctm.web.health.apply.model.request.payment.credit.GatewayCreditCard;
import com.ctm.web.health.apply.model.request.payment.credit.IppCreditCard;
import com.ctm.web.health.apply.model.request.payment.details.Details;
import com.ctm.web.health.apply.model.request.payment.medicare.Medicare;
import com.fasterxml.jackson.annotation.JsonInclude;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Payment {

    private final Details details;

    private final CreditCard creditCard;

    private final IppCreditCard ippCreditCard;

    private final GatewayCreditCard gatewayCreditCard;

    private final Bank bank;

    private final Medicare medicare;

    private final Claims claims;

    public Payment(final Details details, final CreditCard creditCard, final IppCreditCard ippCreditCard,
                   final GatewayCreditCard gatewayCreditCard, final Bank bank, final Medicare medicare, final Claims claims) {
        this.details = details;
        this.creditCard = creditCard;
        this.ippCreditCard = ippCreditCard;
        this.gatewayCreditCard = gatewayCreditCard;
        this.bank = bank;
        this.medicare = medicare;
        this.claims = claims;
    }

    public Details getDetails() {
        return details;
    }

    public CreditCard getCreditCard() {
        return creditCard;
    }

    public IppCreditCard getIppCreditCard() {
        return ippCreditCard;
    }

    public GatewayCreditCard getGatewayCreditCard() {
        return gatewayCreditCard;
    }

    public Bank getBank() {
        return bank;
    }

    public Medicare getMedicare() {
        return medicare;
    }

    public Claims getClaims() {
        return claims;
    }
}
