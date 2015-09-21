package com.ctm.providers.health.healthapply.model.request.payment.credit;

import java.util.function.Supplier;

public class Number implements Supplier<String> {

    private final String number;

    public Number(final String number) {
        this.number = number;
    }

    @Override
    public String get() {
        return number;
    }
}