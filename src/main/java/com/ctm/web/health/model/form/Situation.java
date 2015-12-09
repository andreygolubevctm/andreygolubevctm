package com.ctm.web.health.model.form;

public class Situation {

    private String healthCvr;

    private String location;

    private String state;

    private String suburb;

    private String postcode;

    private String healthSitu;

    private String singleProvider;

    public String getHealthCvr() {
        return healthCvr;
    }

    public void setHealthCvr(String healthCvr) {
        this.healthCvr = healthCvr;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getHealthSitu() {
        return healthSitu;
    }

    public void setHealthSitu(String healthSitu) {
        this.healthSitu = healthSitu;
    }

    public String getSingleProvider() {
        return singleProvider;
    }

    public void setSingleProvider(String singleProvider) {
        this.singleProvider = singleProvider;
    }
}