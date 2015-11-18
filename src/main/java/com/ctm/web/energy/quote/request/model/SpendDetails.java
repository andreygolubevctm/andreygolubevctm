package com.ctm.web.energy.quote.request.model;


public class SpendDetails extends EstimateDetails {

    private Period period;
    private float spend;

    public Period getPeriod() {
        return period;
    }

    public void setPeriod(Period period) {
        this.period = period;
    }

    public float getSpend() {
        return spend;
    }

    public void setSpend(float spend) {
        this.spend = spend;
    }
}
