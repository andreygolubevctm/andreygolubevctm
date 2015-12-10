package com.ctm.web.energy.apply.model.request;


public class EnergyApplicationPayload {

    private Application application;
    private Partner partner;

    private EnergyApplicationPayload(){

    }

    public Application getApplication() {
        return application;
    }

    public Partner getPartner() {
        return partner;
    }
}
