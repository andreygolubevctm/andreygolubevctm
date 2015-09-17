package com.ctm.providers.health.healthapply.model.request.payment.credit;

import com.ctm.providers.health.healthapply.model.request.payment.common.Expiry;
import com.fasterxml.jackson.annotation.JsonProperty;

public class CreditCard {

    @JsonProperty("type")
    private final Type creditCardType;
    @JsonProperty("name")
    private final Name creditCardName;
    @JsonProperty("number")
    private final Number creditCardNumber;

    private final Expiry expiry;

    private final CCV ccv;

    public CreditCard(final Type creditCardType, final Name creditCardName, final Number creditCardNumber, final Expiry expiry, final CCV ccv) {
        this.creditCardType = creditCardType;
        this.creditCardName = creditCardName;
        this.creditCardNumber = creditCardNumber;
        this.expiry = expiry;
        this.ccv = ccv;
    }



}
