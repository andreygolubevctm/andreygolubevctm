package com.ctm.energy.quote.request.model.usage;


import com.ctm.energy.quote.request.model.ElectricityMeterType;

import java.math.BigDecimal;

public class TimeOfUseUsage implements ElectricityUsage {

    private BigDecimal peakUsage;
    private BigDecimal shoulderUsage;
    private BigDecimal offPeakUsage;
    private ElectricityMeterType meterType = ElectricityMeterType.TimeOfUse;

    public TimeOfUseUsage(BigDecimal peakUsage, BigDecimal offPeakUsage, BigDecimal shoulderUsage) {
        this.peakUsage = peakUsage;
        this.shoulderUsage = shoulderUsage;
        this.offPeakUsage = offPeakUsage;
    }

    private TimeOfUseUsage(){

    }

    public BigDecimal getPeakUsage() {
        return peakUsage;
    }

    public BigDecimal getShoulderUsage() {
        return shoulderUsage;
    }

    public BigDecimal getOffPeakUsage() {
        return offPeakUsage;
    }

    @Override
    public ElectricityMeterType getMeterType() {
        return meterType;
    }
}
