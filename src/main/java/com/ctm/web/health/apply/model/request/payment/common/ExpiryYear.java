package com.ctm.web.health.apply.model.request.payment.common;

import java.util.function.Supplier;

public class ExpiryYear implements Supplier<String> {

    private final String cardExpiryYear;

    public ExpiryYear(final String value) {
        cardExpiryYear = value;

    }

    @Override
    public String get() {
        return cardExpiryYear;
    }
}