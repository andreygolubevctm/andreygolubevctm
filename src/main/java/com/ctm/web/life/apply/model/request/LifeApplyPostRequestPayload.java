package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class LifeApplyPostRequestPayload implements Request {
    private Long transactionId;
    private String clientIpAddress;
    private String environmentOverride;

    private String request_type;
    private String client_product_id;
    private String partner_product_id;
    private String api_ref;
    private String vertical;
    private String partner_quote;
    private String company;
    private String partnerBrand;

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
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
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    @Override
    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

}
