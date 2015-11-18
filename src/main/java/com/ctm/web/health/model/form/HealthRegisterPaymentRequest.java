package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.Request;

public class HealthRegisterPaymentRequest implements Request {

    private String clientIpAddress;

    private Long transactionId;

    private String environmentOverride;

    private String sst;

    private String cardType;

    private String token;

    private String maskedcardno;

    private String responsecode;

    private String responseresult;

    private String sessionId;

    private String providerId;

    @Override
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    public String getSst() {
        return sst;
    }

    public void setSst(String sst) {
        this.sst = sst;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getMaskedcardno() {
        return maskedcardno;
    }

    public void setMaskedcardno(String maskedcardno) {
        this.maskedcardno = maskedcardno;
    }

    public String getResponsecode() {
        return responsecode;
    }

    public void setResponsecode(String responsecode) {
        this.responsecode = responsecode;
    }

    public String getResponseresult() {
        return responseresult;
    }

    public void setResponseresult(String responseresult) {
        this.responseresult = responseresult;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }
}
