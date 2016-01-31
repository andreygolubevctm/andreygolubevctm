package com.ctm.web.energy.form.model;

import com.ctm.energy.quote.request.model.HouseholdType;


public class Energy {
    private String currentSupplier;
    private float amount;
    private float days;
    private Rate peak;
    private Rate offpeak;
    private Rate shoulder;
    private HouseholdType usage;

    public HouseholdType getUsage() {
        return usage;
    }

    public void setUsage(HouseholdType usage) {
        this.usage = usage;
    }

    public String getCurrentSupplier() {
        return currentSupplier;
    }

    public void setCurrentSupplier(String currentSupplier) {
        this.currentSupplier = currentSupplier;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public float getDays() {
        return days;
    }

    public void setDays(float days) {
        this.days = days;
    }

    public Rate getPeak() {
        return peak;
    }

    public void setPeak(Rate peak) {
        this.peak = peak;
    }

    public Rate getOffpeak() {
        return offpeak;
    }

    public void setOffpeak(Rate offpeak) {
        this.offpeak = offpeak;
    }

    public Rate getShoulder() {
        return shoulder;
    }

    public void setShoulder(Rate shoulder) {
        this.shoulder = shoulder;
    }
}
