package com.ctm.web.health.model.form;

public class Bank extends BankDetails {

    // Provider Use: HCF
    // integer
    private Integer day;

    // Provider Use: AUF
    // Format yyyy-MM-dd
    private String policyDay;

    // Provider Use: AHM
    // Format yyyy-MM-dd
    private String paymentDay;

    private String claims;

    private BankDetails claim;

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

    public String getClaims() {
        return claims;
    }

    public void setClaims(String claims) {
        this.claims = claims;
    }

    public BankDetails getClaim() {
        return claim;
    }

    public void setClaim(BankDetails claim) {
        this.claim = claim;
    }
}
