package com.ctm.web.energy.form.model;


public class Usage {
    private Energy electricity;
    private Energy gas;
    private Rate peak;
    private Rate offPeak;

    public Usage(){

    }

    public Energy getElectricity() {
        return electricity;
    }

    public void setElectricity(Energy electricity) {
        this.electricity = electricity;
    }

    public Energy getGas() {
        return gas;
    }

    public void setGas(Energy gas) {
        this.gas = gas;
    }

    public Rate getPeak() {
        return peak;
    }

    public void setPeak(Rate peak) {
        this.peak = peak;
    }

    public Rate getOffPeak() {
        return offPeak;
    }

    public void setOffPeak(Rate offPeak) {
        this.offPeak = offPeak;
    }
}
