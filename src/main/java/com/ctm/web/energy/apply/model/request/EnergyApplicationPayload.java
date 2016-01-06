package com.ctm.web.energy.apply.model.request;

import com.ctm.web.energy.form.model.HouseHoldDetailsWebRequest;

public class EnergyApplicationPayload {

    private Application application;
    private Partner partner;
    private HouseHoldDetailsWebRequest householdDetails;

    public Application getApplication() {
        return application;
    }

    public Partner getPartner() {
        return partner;
    }

    public void setApplication(Application application) {
        this.application = application;
    }

    public void setPartner(Partner partner) {
        this.partner = partner;
    }

    public HouseHoldDetailsWebRequest getHouseholdDetails() {
        return householdDetails;
    }

    public void setHouseholdDetails(HouseHoldDetailsWebRequest householdDetails) {
        this.householdDetails = householdDetails;
    }
}