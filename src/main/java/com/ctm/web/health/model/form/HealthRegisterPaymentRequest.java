package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.RequestImpl;

public class HealthRegisterPaymentRequest extends RequestImpl {

    private String sst;

    private String cardType;

    private String token;

    private String maskedcardno;

    private String responsecode;

    private String responseresult;

    private String sessionId;

    private String providerId;

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

    @Override
    public String toString() {
        return "HealthRegisterPaymentRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", sst='" + sst + '\'' +
                ", cardType='" + cardType + '\'' +
                ", token='" + token + '\'' +
                ", maskedcardno='" + maskedcardno + '\'' +
                ", responsecode='" + responsecode + '\'' +
                ", responseresult='" + responseresult + '\'' +
                ", sessionId='" + sessionId + '\'' +
                ", providerId='" + providerId + '\'' +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
