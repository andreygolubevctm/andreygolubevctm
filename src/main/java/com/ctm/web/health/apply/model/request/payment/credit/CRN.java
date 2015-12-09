package com.ctm.web.health.apply.model.request.payment.credit;

import java.util.function.Supplier;

public class CRN implements Supplier<String> {

    private final String value;

    public CRN(final String value) {
        this.value = value;
    }

    @Override
    public String get() {
        return value;
    }
}