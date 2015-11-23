package com.ctm.web.energy.form.model;


public class EstimateDetails {

    private Gas gas;
    private Electricity electricity;
    private Spend spend;


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
}
