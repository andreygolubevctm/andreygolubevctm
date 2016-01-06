package com.ctm.web.energy.form.model;


public class EstimateDetails {

    private Gas gas;
    private Electricity electricity;
    private Spend spend;
    private Usage usage;

    public EstimateDetails(){

    }


    public Electricity getElectricity() {
        return electricity;
    }

    public Gas getGas() {
        return gas;
    }

    public void setElectricity(Electricity electricity) {
        this.electricity = electricity;
    }

    public void setGas(Gas gas) {
        this.gas = gas;
    }

    public Spend getSpend() {
        return spend;
    }

    public void setSpend(Spend spend) {
        this.spend = spend;
    }

    public Usage getUsage() {
        return usage;
    }

    public void setUsage(Usage usage) {
        this.usage = usage;
    }
}
