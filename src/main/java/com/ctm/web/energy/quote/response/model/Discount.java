package com.ctm.web.energy.quote.response.model;


public class Discount {

    private String payOnTime;
    private String ebilling;
    private String guaranteed;
    private String other;
    private String details;

    public String getPayOnTime() {
        return payOnTime;
    }

    public void setPayOnTime(String payOnTime) {
        this.payOnTime = payOnTime;
    }

    public String getEbilling() {
        return ebilling;
    }

    public void setEbilling(String ebilling) {
        this.ebilling = ebilling;
    }

    public String getGuaranteed() {
        return guaranteed;
    }

    public void setGuaranteed(String guaranteed) {
        this.guaranteed = guaranteed;
    }

    public String getOther() {
        return other;
    }

    public void setOther(String other) {
        this.other = other;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
