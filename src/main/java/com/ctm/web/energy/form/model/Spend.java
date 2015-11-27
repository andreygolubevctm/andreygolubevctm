package com.ctm.web.energy.form.model;

/**
 * Created by lbuchanan on 18/11/2015.
 */
public class Spend {
    private SpendEnergy electricity;
    private SpendEnergy gas;

    public Spend(){

    }

    public SpendEnergy getElectricity() {
        return electricity;
    }

    public void setElectricity(SpendEnergy electricity) {
        this.electricity = electricity;
    }

    public SpendEnergy getGas() {
        return gas;
    }

    public void setGas(SpendEnergy gas) {
        this.gas = gas;
    }
}
