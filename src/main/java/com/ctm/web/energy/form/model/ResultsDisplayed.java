package com.ctm.web.energy.form.model;


import com.ctm.web.core.validation.Name;

public class ResultsDisplayed {
    private YesNo preferEBilling;
    private YesNo preferNoContract;
    private YesNo preferRenewableEnergy;
    private YesNo optinPhone;

    @Name
    private String firstName;

    private String phone;


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


    public YesNo getOptinPhone() {
        return optinPhone;
    }

    public void setOptinPhone(YesNo optinPhone) {
        this.optinPhone = optinPhone;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
