package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.formData.YesNo;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;

@JsonIgnoreProperties(ignoreUnknown = true)
public class LifeApplyWebRequest implements Request {

    @NotNull
    private Long transactionId;

    private String clientIpAddress;
    private String environmentOverride;
    private String request_type;
    @NotNull
    private String client_product_id;
    private String partner_product_id;
    private String api_ref;
    private String vertical;
    private YesNo partner_quote;
    @NotNull
    private String company;
    private String partnerBrand;
    private String lead_number;
    private LocalDateTime requestAt;

    public LifeApplyWebRequest() {}

    public void setRequest_type(String request_type) {
        this.request_type = request_type;
    }

    public void setClient_product_id(String client_product_id) {
        this.client_product_id = client_product_id;
    }

    public void setPartner_product_id(String partner_product_id) {
        this.partner_product_id = partner_product_id;
    }

    public void setApi_ref(String api_ref) {
        this.api_ref = api_ref;
    }

    public void setVertical(String vertical) {
        this.vertical = vertical;
    }

    public void setPartner_quote(YesNo partner_quote) {
        this.partner_quote = partner_quote;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public void setPartnerBrand(String partnerBrand) {
        this.partnerBrand = partnerBrand;
    }

    public void setLead_number(String lead_number) {
        this.lead_number = lead_number;
    }

    public String getLead_number() {
        return lead_number;
    }

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
    public void setRequestAt(LocalDateTime requestAt) {
        this.requestAt = requestAt;
    }

    @Override
    public LocalDateTime getRequestAt() {
        return requestAt;
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
