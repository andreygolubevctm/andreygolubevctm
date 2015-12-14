package com.ctm.web.health.apply.model.request.payment.details;

import java.util.function.Supplier;

public class RebatePercentage implements Supplier<Double> {

    private final Double rebatePercentage;

    public RebatePercentage(final Double rebatePercentage) {
        this.rebatePercentage = rebatePercentage;
    }

    @Override
    public Double get() {
        return rebatePercentage;
    }
}
