package com.ctm.energy.quote.request.model.usage;


import com.ctm.energy.quote.request.model.ElectricityMeterType;

import java.math.BigDecimal;

public class SingleRateUsage implements ElectricityUsage {

    ElectricityMeterType meterType = ElectricityMeterType.Single;
    private BigDecimal standardUsage;

    @Override
    public ElectricityMeterType getMeterType() {
        return meterType;
    }

    public SingleRateUsage(BigDecimal standardUsage) {
        this.standardUsage = standardUsage;
    }

    private SingleRateUsage(){

    }

    public BigDecimal getStandardUsage() {
        return standardUsage;
    }
}
