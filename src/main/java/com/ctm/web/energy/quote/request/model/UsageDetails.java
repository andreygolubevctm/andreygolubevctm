package com.ctm.web.energy.quote.request.model;


public class UsageDetails extends EstimateDetails {
    private float peakUsage = 0;
    private float offPeakUsage = 0;

    public float getPeakUsage() {
        return peakUsage;
    }

    public void setPeakUsage(float peakUsage) {
        this.peakUsage = peakUsage;
    }

    public float getOffPeakUsage() {
        return offPeakUsage;
    }

    public void setOffPeakUsage(float offPeakUsage) {
        this.offPeakUsage = offPeakUsage;
    }
}
