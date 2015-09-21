package com.ctm.providers.health.healthapply.model.request.payment.details;

import java.util.function.Supplier;

public class LifetimeHealthCoverLoading implements Supplier<Double> {

    private final Double value;

    public LifetimeHealthCoverLoading(final Double value) {
        this.value = value;
    }

    @Override
    public Double get() {
        return value;
    }
}