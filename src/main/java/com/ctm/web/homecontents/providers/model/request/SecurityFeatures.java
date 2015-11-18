package com.ctm.web.homecontents.providers.model.request;

public class SecurityFeatures {

    private Boolean externalSiren;

    private Boolean internalSiren;

    private Boolean strobeLight;

    private Boolean backToBase;

    public Boolean isExternalSiren() {
        return externalSiren;
    }

    public void setExternalSiren(Boolean externalSiren) {
        this.externalSiren = externalSiren;
    }

    public Boolean isInternalSiren() {
        return internalSiren;
    }

    public void setInternalSiren(Boolean internalSiren) {
        this.internalSiren = internalSiren;
    }

    public Boolean isStrobeLight() {
        return strobeLight;
    }

    public void setStrobeLight(Boolean strobeLight) {
        this.strobeLight = strobeLight;
    }

    public Boolean isBackToBase() {
        return backToBase;
    }

    public void setBackToBase(Boolean backToBase) {
        this.backToBase = backToBase;
    }
}
