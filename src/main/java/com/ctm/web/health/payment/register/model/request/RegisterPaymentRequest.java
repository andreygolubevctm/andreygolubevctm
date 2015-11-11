package com.ctm.web.health.payment.register.model.request;

import java.util.List;

public class RegisterPaymentRequest {

    private String sst;

    private String referenceId;

    private String maskedCardNumber;

    private String cardType;

    private String token;

    private String responseCode;

    private String responseResult;

    private List<String> providerFilter;

    public String getSst() {
        return sst;
    }

    public void setSst(String sst) {
        this.sst = sst;
    }

    public String getReferenceId() {
        return referenceId;
    }

    public void setReferenceId(String referenceId) {
        this.referenceId = referenceId;
    }

    public String getMaskedCardNumber() {
        return maskedCardNumber;
    }

    public void setMaskedCardNumber(String maskedCardNumber) {
        this.maskedCardNumber = maskedCardNumber;
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

    public String getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(String responseCode) {
        this.responseCode = responseCode;
    }

    public String getResponseResult() {
        return responseResult;
    }

    public void setResponseResult(String responseResult) {
        this.responseResult = responseResult;
    }

    public List<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(List<String> providerFilter) {
        this.providerFilter = providerFilter;
    }
}
