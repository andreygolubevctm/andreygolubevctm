package com.ctm.web.energy.form.model;

public class Electricity extends Energy{

    Rate peak;
    Rate offpeak;
    Rate shoulder;
    MeterType meter;

    public Electricity(){

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

    public MeterType getMeter() {
        return meter;
    }

    public void setMeter(MeterType meter) {
        this.meter = meter;
    }

}
