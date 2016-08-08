package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.RequestImpl;

public class HealthRegisterPaymentRequest extends RequestImpl {

    private String sst;

    private String cardtype;

    private String token;

    private String maskedcardno;

    private String responsecode;

    private String responseresult;

    private String sessionid;

    private String providerId;

    public String getSst() {
        return sst;
    }

    public void setSst(String sst) {
        this.sst = sst;
    }

    public String getCardtype() {
        return cardtype;
    }

    public void setCardtype(String cardtype) {
        this.cardtype = cardtype;
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

    public String getSessionid() {
        return sessionid;
    }

    public void setSessionid(String sessionid) {
        this.sessionid = sessionid;
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
                ", cardtype='" + cardtype + '\'' +
                ", token='" + token + '\'' +
                ", maskedcardno='" + maskedcardno + '\'' +
                ", responsecode='" + responsecode + '\'' +
                ", responseresult='" + responseresult + '\'' +
                ", sessionid='" + sessionid + '\'' +
                ", providerId='" + providerId + '\'' +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
