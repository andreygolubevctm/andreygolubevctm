package com.ctm.web.energy.apply.model.request;


public class Application {
    private Details details;
    private ThingsToKnow thingsToKnow;

    private Application(){

    }

    public Details getDetails() {
        return details;
    }

    public ThingsToKnow getThingsToKnow() {
        return thingsToKnow;
    }

    public void setDetails(Details details) {
        this.details = details;
    }

    public void setThingsToKnow(ThingsToKnow thingsToKnow) {
        this.thingsToKnow = thingsToKnow;
    }
}
