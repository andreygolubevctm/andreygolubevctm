package com.ctm.web.energy.form.model;

import com.ctm.energy.quote.request.model.ElectricityMeterType;

public class Electricity extends Energy{

    Rate peak;
    Rate offpeak;
    Rate shoulder;
    ElectricityMeterType meter;

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

    public ElectricityMeterType getMeter() {
        return meter;
    }

    public void setMeter(ElectricityMeterType meter) {
        this.meter = meter;
    }

}
