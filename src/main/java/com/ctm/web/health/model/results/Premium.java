package com.ctm.web.health.model.results;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.io.Serializable;

@JsonPropertyOrder({"weekly", "fortnightly", "monthly", "quarterly", "halfyearly", "annually"})
public class Premium implements Serializable {

    private Price fortnightly;

    private Price monthly;

    private Price halfyearly;

    private Price quarterly;

    private Price weekly;

    private Price annually;

    public Price getFortnightly() {
        return fortnightly;
    }

    public void setFortnightly(Price fortnightly) {
        this.fortnightly = fortnightly;
    }

    public Price getMonthly() {
        return monthly;
    }

    public void setMonthly(Price monthly) {
        this.monthly = monthly;
    }

    public Price getHalfyearly() {
        return halfyearly;
    }

    public void setHalfyearly(Price halfyearly) {
        this.halfyearly = halfyearly;
    }

    public Price getQuarterly() {
        return quarterly;
    }

    public void setQuarterly(Price quarterly) {
        this.quarterly = quarterly;
    }

    public Price getWeekly() {
        return weekly;
    }

    public void setWeekly(Price weekly) {
        this.weekly = weekly;
    }

    public Price getAnnually() {
        return annually;
    }

    public void setAnnually(Price annually) {
        this.annually = annually;
    }
}
