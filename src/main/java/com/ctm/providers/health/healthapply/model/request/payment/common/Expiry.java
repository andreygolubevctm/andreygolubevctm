package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.ctm.providers.health.healthapply.model.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Expiry {

    @JsonProperty("cardExpiryMonth")
    @JsonSerialize(using = TypeSerializer.class)
    private final ExpiryMonth cardExpiryMonth;

    @JsonProperty("cardExpiryYear")
    @JsonSerialize(using = TypeSerializer.class)
    private final ExpiryYear cardExpiryYear;

    public Expiry(final ExpiryMonth cardExpiryMonth, final ExpiryYear cardExpiryYear) {
        this.cardExpiryMonth = cardExpiryMonth;
        this.cardExpiryYear = cardExpiryYear;
    }


}
