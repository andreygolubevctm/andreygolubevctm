package com.ctm.web.energy.form.model;


import com.ctm.web.core.validation.Name;

public class ResultsDisplayed {
    private YesNo preferEBilling;
    private YesNo preferNoContract;
    private YesNo preferRenewableEnergy;

    @Name
    private String firstName;

    @Name
    private String lastName;

    public YesNo getPreferEBilling() {
        return preferEBilling;
    }

    public void setPreferEBilling(YesNo preferEBilling) {
        this.preferEBilling = preferEBilling;
    }

    public YesNo getPreferNoContract() {
        return preferNoContract;
    }

    public void setPreferNoContract(YesNo preferNoContract) {
        this.preferNoContract = preferNoContract;
    }

    public YesNo getPreferRenewableEnergy() {
        return preferRenewableEnergy;
    }

    public void setPreferRenewableEnergy(YesNo preferRenewableEnergy) {
        this.preferRenewableEnergy = preferRenewableEnergy;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
}
