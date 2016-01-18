package com.ctm.web.health.apply.model.request.payment.credit;

import java.util.function.Supplier;

public class CCV implements Supplier<String> {

    private final String ccv;

    public CCV(final String ccv) {
        this.ccv = ccv;
    }

    @Override
    public String get() {
        return ccv;
    }
}