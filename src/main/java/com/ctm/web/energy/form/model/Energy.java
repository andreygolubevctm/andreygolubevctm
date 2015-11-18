package com.ctm.web.energy.form.model;

/**
 * Created by lbuchanan on 18/11/2015.
 */
public class Energy {
    private String currentSupplier;
    private float peakUsage = 0;
    private float offPeakUsage = 0;

    public String getCurrentSupplier() {
        return currentSupplier;
    }

    public void setCurrentSupplier(String currentSupplier) {
        this.currentSupplier = currentSupplier;
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
}
