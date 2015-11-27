package com.ctm.web.energy.form.model;


public class Usage {
    private Energy electricity;
    private Energy gas;

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
}
