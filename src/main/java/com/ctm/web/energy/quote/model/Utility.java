package com.ctm.web.energy.quote.model;

/**
 * Created by lbuchanan on 18/11/2015.
 */
public class Utility {
    private String currentSupplier;
    private Period period;
    private float spend = 0;
    private float peakUsage = 0;
    private float offPeakUsage = 0;

    public String getCurrentSupplier() {
        return currentSupplier;
    }

    public void setCurrentSupplier(String currentSupplier) {
        this.currentSupplier = currentSupplier;
    }

    public float getSpend() {
        return spend;
    }

    public void setSpend(float spend) {
        this.spend = spend;
    }

    public float getPeakUsage() {
        return peakUsage;
    }

    public void setPeakUsage(float peakUsage) {
        this.peakUsage = peakUsage;
    }

    public float getOffPeakUsage() {
        return offPeakUsage;
    }

    public Period getPeriod() {
        return period;
    }

    public void setPeriod(Period period) {
        this.period = period;
    }
}
