package com.ctm.web.health.email.model;

import com.ctm.web.core.email.model.EmailModel;

public class HealthApplicationEmailModel extends EmailModel {

    private String firstName;

    private String bccEmail;

    private boolean optIn;

    private String okToCall;

    private String phoneNumber;

    private long transactionId;

    private String actionUrl;

    private String unsubscribeURL;

    private String productName;

    private String healthFund;

    private String providerPhoneNumber;

    private String hospitalPdsUrl;

    private String extrasPdsUrl;

    public String getBccEmail() {
        return bccEmail;
    }

    public void setBccEmail(String bccEmail) {
        this.bccEmail = bccEmail;
    }

    public String getOkToCall() {
        return okToCall;
    }

    public void setOkToCall(String okToCall) {
        this.okToCall = okToCall;
    }

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }

    @Override
    public String getUnsubscribeURL() {
        return unsubscribeURL;
    }

    @Override
    public void setUnsubscribeURL(String unsubscribeURL) {
        this.unsubscribeURL = unsubscribeURL;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getHealthFund() {
        return healthFund;
    }

    public void setHealthFund(String healthFund) {
        this.healthFund = healthFund;
    }

    public String getProviderPhoneNumber() {
        return providerPhoneNumber;
    }

    public void setProviderPhoneNumber(String providerPhoneNumber) {
        this.providerPhoneNumber = providerPhoneNumber;
    }

    public String getHospitalPdsUrl() {
        return hospitalPdsUrl;
    }

    public void setHospitalPdsUrl(String hospitalPdsUrl) {
        this.hospitalPdsUrl = hospitalPdsUrl;
    }

    public String getExtrasPdsUrl() {
        return extrasPdsUrl;
    }

    public void setExtrasPdsUrl(String extrasPdsUrl) {
        this.extrasPdsUrl = extrasPdsUrl;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public boolean isOptIn() {
        return optIn;
    }

    public void setOptIn(boolean optIn) {
        this.optIn = optIn;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
