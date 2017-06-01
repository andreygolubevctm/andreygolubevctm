package com.ctm.energy.quote.response.model.plan;

import com.ctm.interfaces.common.types.ValueType;

import java.math.BigDecimal;


public class EstimatedCost extends ValueType<BigDecimal> {
    public EstimatedCost(BigDecimal value) {
        super(value);
    }
}