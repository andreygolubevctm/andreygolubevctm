package com.ctm.providers.health.healthpayment.authorise.model.response;

public class AuthorisePaymentQuote {

    private String service;

    private String productId;

    private Status status;

    private String tokenisationReferenceId;

    private String tokenisationUrl;

    private String sst;

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

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
