package com.ctm.web.health.model.request;

import com.ctm.web.core.model.PageRequest;


public class BaseHealthRequest extends PageRequest {

    private boolean isCallCentre;


    public void setIsCallCentre(boolean isCallCentre) {
        this.isCallCentre = isCallCentre;
    }

    public boolean isCallCentre() {
        return isCallCentre;
    }

}
