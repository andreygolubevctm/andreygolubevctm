package com.ctm.energy.quote.request.model;


import com.ctm.energy.quote.request.model.usage.ElectricityUsage;
import com.ctm.energy.quote.request.model.usage.SingleRateUsage;
import com.ctm.energy.quote.request.model.usage.TimeOfUseUsage;
import com.ctm.energy.quote.request.model.usage.TwoRateUsage;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

import java.math.BigDecimal;

public class ElectricityUsageDetails extends UsageDetails {

    @JsonTypeInfo(use = JsonTypeInfo.Id.NAME,
    include = JsonTypeInfo.As.EXISTING_PROPERTY,
    property = "meterType")
    @JsonSubTypes({
        @JsonSubTypes.Type(value = SingleRateUsage.class, name = "Single"),
        @JsonSubTypes.Type(value = TwoRateUsage.class, name = "TwoRate"),
        @JsonSubTypes.Type(value = TimeOfUseUsage.class, name = "TimeOfUse")
    })
    private ElectricityUsage usage;

    public ElectricityUsageDetails(BigDecimal billAmount, Integer billDays, ElectricityUsage usage) {
        super( billAmount,  billDays);
        this.usage = usage;
    }

    @SuppressWarnings("unused")
    private ElectricityUsageDetails(){

    }

    public ElectricityUsage getUsage() {
        return usage;
    }
}
