package com.ctm.model.health.form;

public class Bank extends BankDetails {

    private String day;

    // Provider Use: AUF
    // Format yyyy-MM-dd
    private String policyDay;

    // Provider Use: AHM
    // Format yyyy-MM-dd
    private String paymentDay;

    private String claims;

    private BankDetails claim;

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
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
