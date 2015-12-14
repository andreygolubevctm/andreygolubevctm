package com.ctm.web.energy.apply.model.request;

public class EnergyApplicationPayload {

    private Application application;
    private Partner partner;
    private HouseholdDetails householdDetails;

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

    public HouseholdDetails getHouseholdDetails() {
        return householdDetails;
    }

    public void setHouseholdDetails(HouseholdDetails householdDetails) {
        this.householdDetails = householdDetails;
    }
}
