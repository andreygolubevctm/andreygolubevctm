package com.ctm.providers.health.healthapply.model.request.payment.credit;

import java.util.function.Supplier;

public class Type implements Supplier<String> {

    private final String type;

    public Type(final String type) {
        this.type = type;
    }

    @Override
    public String get() {
        return type;
    }
}