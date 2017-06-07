package com.ctm.energy.quote.request.model;

import com.ctm.energy.quote.request.model.usage.GasUsage;

import java.math.BigDecimal;


public class GasUsageDetails extends UsageDetails {

    private GasUsage usage;

    public GasUsageDetails(BigDecimal billAmount, Integer billDays, GasUsage usage) {
        super( billAmount,  billDays);
        this.usage = usage;
    }

    @SuppressWarnings("unused")
    private GasUsageDetails(){
        super();
    }

    public GasUsage getUsage() {
        return usage;
    }
}
