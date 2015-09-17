package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Expiry {

    @JsonProperty("cardExpiryMonth")
    private final ExpiryMonth cardExpiryMonth;

    @JsonProperty("cardExpiryYear")
    private final ExpiryYear cardExpiryYear;

    public Expiry(final ExpiryMonth cardExpiryMonth, final ExpiryYear cardExpiryYear) {
        this.cardExpiryMonth = cardExpiryMonth;
        this.cardExpiryYear = cardExpiryYear;
    }


}
