package com.ctm.web.health.model.form;

public class Credit {

    private String type;

    private String name;

    private String number;

    private Expiry expiry;

    private String ccv;

    private Integer day;

    // Provider Use: AUF
    // Format yyyy-MM-dd
    private String policyDay;

    // Provider Use: AHM
    // Format yyyy-MM-dd
    private String paymentDay;

    private Ipp ipp;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Expiry getExpiry() {
        return expiry;
    }

    public void setExpiry(Expiry expiry) {
        this.expiry = expiry;
    }

    public String getCcv() {
        return ccv;
    }

    public void setCcv(String ccv) {
        this.ccv = ccv;
    }

    public Integer getDay() {
        return day;
    }

    public void setDay(Integer day) {
        this.day = day;
    }

    public String getPaymentDay() {
        return paymentDay;
    }

    public void setPaymentDay(String paymentDay) {
        this.paymentDay = paymentDay;
    }

    public String getPolicyDay() {
        return policyDay;
    }

    public void setPolicyDay(String policyDay) {
        this.policyDay = policyDay;
    }

    public Ipp getIpp() {
        return ipp;
    }

    public void setIpp(Ipp ipp) {
        this.ipp = ipp;
    }
}
