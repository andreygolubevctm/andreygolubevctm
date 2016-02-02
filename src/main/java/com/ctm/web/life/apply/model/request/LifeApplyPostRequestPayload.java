package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.ctm.core.energy.form.model.YesNo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.validation.constraints.NotNull;

@JsonIgnoreProperties(ignoreUnknown = true)
public class LifeApplyPostRequestPayload implements Request {

    @NotNull
    private Long transactionId;

    private String clientIpAddress;
    private String environmentOverride;
    private String request_type;
    private String client_product_id;
    private String partner_product_id;
    private String api_ref;
    private String vertical;
    private YesNo partner_quote;
    private String company;
    private String partnerBrand;
    private String lead_number;

    public String getCompany() {
        return company;
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

    public String getRequest_type() {
        return request_type;
    }

    public String getClient_product_id() {
        return client_product_id;
    }

    public String getPartner_product_id() {
        return partner_product_id;
    }

    public String getApi_ref() {
        return api_ref;
    }

    public String getVertical() {
        return vertical;
    }

    public YesNo getPartner_quote() {
        return partner_quote;
    }

    public String getPartnerBrand() {
        return partnerBrand;
    }
}
