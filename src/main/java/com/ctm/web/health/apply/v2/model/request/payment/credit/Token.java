package com.ctm.web.health.apply.v2.model.request.payment.credit;

import java.util.function.Supplier;

public class Token implements Supplier<String> {

    private final String value;

    public Token(final String value) {
        this.value = value;
    }

    @Override
    public String get() {
        return value;
    }
}