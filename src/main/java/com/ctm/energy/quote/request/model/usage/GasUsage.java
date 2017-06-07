package com.ctm.energy.quote.request.model.usage;


import java.math.BigDecimal;

public class GasUsage implements Usage {

    private BigDecimal standardUsage;
    private BigDecimal offPeakUsage;

    public GasUsage(BigDecimal standardUsage, BigDecimal offPeakUsage) {
        this.standardUsage = standardUsage;
        this.offPeakUsage = offPeakUsage;
    }

    @SuppressWarnings("unused")
    private GasUsage(){

    }

    public BigDecimal getStandardUsage() {
        return standardUsage;
    }

    public BigDecimal getOffPeakUsage() {
        return offPeakUsage;
    }
}
