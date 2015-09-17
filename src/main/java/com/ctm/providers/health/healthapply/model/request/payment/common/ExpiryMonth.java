package com.ctm.providers.health.healthapply.model.request.payment.common;

public class ExpiryMonth {

    private final String cardExpiryMonth;

    public ExpiryMonth (final String value) {
        if(value.matches("^[1-9]$")) {
            this.cardExpiryMonth = "0" + value;
        } else {
            cardExpiryMonth = value;
        }

    }

}