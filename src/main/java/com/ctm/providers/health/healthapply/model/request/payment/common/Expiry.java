package com.ctm.providers.health.healthapply.model.request.payment.common;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

public class Expiry {

    @JsonProperty("cardExpiryMonth")
    private ExpiryMonth expiryMonth;

    @JsonProperty("cardExpiryYear")
    private ExpiryYear expiryYear;

    public Optional<ExpiryMonth> getExpiryMonth() {
        return Optional.ofNullable(expiryMonth);
    }

    public Optional<ExpiryYear> getExpiryYear() {
        return Optional.ofNullable(expiryYear);
    }

    @JsonProperty("cardExpiryMonth")
    private String cardExpiryMonth() {
        return getExpiryMonth().orElse(ExpiryMonth.instanceOf("01")).get();
    }

    @JsonProperty("cardExpiryYear")
    private String cardExpiryYear() {
        return getExpiryYear().orElse(ExpiryYear.instanceOf("00")).get();
    }


}
