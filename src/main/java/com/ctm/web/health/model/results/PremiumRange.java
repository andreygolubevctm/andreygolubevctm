package com.ctm.web.health.model.results;

public class PremiumRange {

    private Range fortnightly;

    private Range monthly;

    private Range yearly;

    public Range getFortnightly() {
        return fortnightly;
    }

    public void setFortnightly(Range fortnightly) {
        this.fortnightly = fortnightly;
    }

    public Range getMonthly() {
        return monthly;
    }

    public void setMonthly(Range monthly) {
        this.monthly = monthly;
    }

    public Range getYearly() {
        return yearly;
    }

    public void setYearly(Range yearly) {
        this.yearly = yearly;
    }
}
