package com.ctm.web.health.apply.model.request.payment.credit;

import java.util.function.Supplier;

public class Name implements Supplier<String> {

    private final String name;

    public Name(final String name) {
        this.name = name;
    }

    @Override
    public String get() {
        return name;
    }
}