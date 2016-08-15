package com.ctm.web.health.payment.authorise.model.response;

public class AuthorisePaymentResponseV2 {

    private Status status;

    private String tokenisationReferenceId;

    private String tokenisationUrl;

    private String sst;

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getTokenisationReferenceId() {
        return tokenisationReferenceId;
    }

    public void setTokenisationReferenceId(String tokenisationReferenceId) {
        this.tokenisationReferenceId = tokenisationReferenceId;
    }

    public String getTokenisationUrl() {
        return tokenisationUrl;
    }

    public void setTokenisationUrl(String tokenisationUrl) {
        this.tokenisationUrl = tokenisationUrl;
    }

    public String getSst() {
        return sst;
    }

    public void setSst(String sst) {
        this.sst = sst;
    }
}
