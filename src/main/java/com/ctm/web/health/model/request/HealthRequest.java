package com.ctm.web.health.model.request;

import com.ctm.model.PageRequest;


public class HealthRequest extends PageRequest {

    private boolean isCallCentre;


    public void setIsCallCentre(boolean isCallCentre) {
        this.isCallCentre = isCallCentre;
    }

    public boolean isCallCentre() {
        return isCallCentre;
    }

}
