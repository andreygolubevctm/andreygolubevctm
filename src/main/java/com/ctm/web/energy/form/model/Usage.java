package com.ctm.web.energy.form.model;


public class Usage {
    private Utility electricity;
    private Utility gas;

    public Utility getElectricity() {
        return electricity;
    }

    public void setElectricity(Utility electricity) {
        this.electricity = electricity;
    }

    public Utility getGas() {
        return gas;
    }

    public void setGas(Utility gas) {
        this.gas = gas;
    }
}
