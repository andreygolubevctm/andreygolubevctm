package com.ctm.web.health.apply.model.request.payment.common;

import org.apache.commons.lang3.StringUtils;

import java.util.function.Supplier;

public class ExpiryDay implements Supplier<String> {

    private final String cardExpiryDay;

    public ExpiryDay(final String value) {
        if (StringUtils.isNotEmpty(value) && value.matches("^[1-9]$")) {
            this.cardExpiryDay = "0" + value;
        } else {
            cardExpiryDay = value;
        }
    }

    @Override
    public String get() {
        return cardExpiryDay;
    }
}
