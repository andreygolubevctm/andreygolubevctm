package com.ctm.energy.quote.request.model.usage;


import com.ctm.energy.quote.request.model.ElectricityMeterType;

import java.math.BigDecimal;

public class TwoRateUsage  implements ElectricityUsage {

    private BigDecimal peakUsage;
    private BigDecimal controlledLoad;
    private final ElectricityMeterType meterType = ElectricityMeterType.TwoRate;

    public TwoRateUsage(BigDecimal peakUsage, BigDecimal controlledLoad) {
        this.peakUsage = peakUsage;
        this.controlledLoad = controlledLoad;
    }

    private TwoRateUsage(){

    }

    public BigDecimal getPeakUsage() {
        return peakUsage;
    }

    public BigDecimal getControlledLoad() {
        return controlledLoad;
    }

    @Override
    public ElectricityMeterType getMeterType() {
        return meterType;
    }
}
