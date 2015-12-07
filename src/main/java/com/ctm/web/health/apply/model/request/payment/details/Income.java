package com.ctm.web.health.apply.model.request.payment.details;

import java.util.function.Supplier;

public class Income implements Supplier<Long> {

    private final long income;

    public Income(final long income) {
        this.income = income;
    }

    @Override
    public Long get() {
        return income;
    }
}