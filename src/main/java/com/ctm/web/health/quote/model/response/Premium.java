package com.ctm.web.health.quote.model.response;

public class Premium {

    private Price annually;

    private Price monthly;

    private Price fortnightly;

    private Price weekly;

    private Price halfYearly;

    private Price quarterly;

    public Price getAnnually() {
        return annually;
    }

    public void setAnnually(Price annually) {
        this.annually = annually;
    }

    public Price getMonthly() {
        return monthly;
    }

    public void setMonthly(Price monthly) {
        this.monthly = monthly;
    }

    public Price getFortnightly() {
        return fortnightly;
    }

    public void setFortnightly(Price fortnightly) {
        this.fortnightly = fortnightly;
    }

    public Price getWeekly() {
        return weekly;
    }

    public void setWeekly(Price weekly) {
        this.weekly = weekly;
    }

    public Price getHalfYearly() {
        return halfYearly;
    }

    public void setHalfYearly(Price halfYearly) {
        this.halfYearly = halfYearly;
    }

    public Price getQuarterly() {
        return quarterly;
    }

    public void setQuarterly(Price quarterly) {
        this.quarterly = quarterly;
    }
}
