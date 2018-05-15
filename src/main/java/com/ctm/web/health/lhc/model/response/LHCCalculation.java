package com.ctm.web.health.lhc.model.response;

public class LHCCalculation {
    private long lhcPercentage;

    public LHCCalculation(long lhcPercentage) {
        this.lhcPercentage = lhcPercentage;
    }

    public long getLhcPercentage() {
        return lhcPercentage;
    }
}
