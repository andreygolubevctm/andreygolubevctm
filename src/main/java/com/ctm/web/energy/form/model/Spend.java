package com.ctm.web.energy.form.model;

/**
 * Created by lbuchanan on 18/11/2015.
 */
public class Spend {
    private SpendUtility electricity;
    private SpendUtility gas;

    public SpendUtility getElectricity() {
        return electricity;
    }

    public void setElectricity(SpendUtility electricity) {
        this.electricity = electricity;
    }

    public SpendUtility getGas() {
        return gas;
    }

    public void setGas(SpendUtility gas) {
        this.gas = gas;
    }
}
