package com.ctm.web.energy.apply.model.request;

public class EnergyApplicationPayload {

    private Application application;
    private Partner partner;

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
}
