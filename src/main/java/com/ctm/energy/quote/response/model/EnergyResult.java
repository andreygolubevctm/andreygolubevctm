package com.ctm.energy.quote.response.model;

import com.ctm.energy.quote.response.model.plan.EstimatedCost;

import java.math.BigDecimal;


public class EnergyResult {

    private  Savings savings;
    private BigDecimal estimatedCost;

    public EnergyResult(EstimatedCost estimatedCost,
                        Savings savings) {
        this.estimatedCost = estimatedCost.get();
        this.savings = savings;
    }

    @SuppressWarnings("unused")
    private EnergyResult(){}

    public Savings getSavings() {
        return savings;
    }

    public BigDecimal getEstimatedCost() {
        return estimatedCost;
    }
}
