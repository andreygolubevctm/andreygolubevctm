package com.ctm.providers.health.healthapply.model.request.payment.common;

import java.util.function.Supplier;

public class ExpiryMonth implements Supplier<String> {

    private final String cardExpiryMonth;

    public ExpiryMonth (final String value) {
        if(value.matches("^[1-9]$")) {
            this.cardExpiryMonth = "0" + value;
        } else {
            cardExpiryMonth = value;
        }

    }

    @Override
    public String get() {
        return cardExpiryMonth;
    }
}