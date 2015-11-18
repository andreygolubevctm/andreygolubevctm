package com.ctm.web.energy.quote.model;


public class SpendDetails extends EstimateDetails {

    private Period period;
    private float spend = 0;
    public float getSpend() {
        return spend;
    }
    public void setSpend(float spend) {
        this.spend = spend;
    }
    public Period getPeriod() {
        return period;
    }
    public void setPeriod(Period period) {
        this.period = period;
    }
}
