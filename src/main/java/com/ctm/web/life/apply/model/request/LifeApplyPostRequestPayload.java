package com.ctm.web.life.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.formData.YesNo;
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

    private LifeApplyPostRequestPayload(Builder builder) {
        setTransactionId(builder.transactionId);
        setClientIpAddress(builder.clientIpAddress);
        setEnvironmentOverride(builder.environmentOverride);
        request_type = builder.request_type;
        client_product_id = builder.client_product_id;
        partner_product_id = builder.partner_product_id;
        api_ref = builder.api_ref;
        vertical = builder.vertical;
        partner_quote = builder.partner_quote;
        company = builder.company;
        partnerBrand = builder.partnerBrand;
        lead_number = builder.lead_number;
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


    public static final class Builder {
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

        public Builder() {
        }

        public Builder transactionId(Long val) {
            transactionId = val;
            return this;
        }

        public Builder clientIpAddress(String val) {
            clientIpAddress = val;
            return this;
        }

        public Builder environmentOverride(String val) {
            environmentOverride = val;
            return this;
        }

        public Builder request_type(String val) {
            request_type = val;
            return this;
        }

        public Builder client_product_id(String val) {
            client_product_id = val;
            return this;
        }

        public Builder partner_product_id(String val) {
            partner_product_id = val;
            return this;
        }

        public Builder api_ref(String val) {
            api_ref = val;
            return this;
        }

        public Builder vertical(String val) {
            vertical = val;
            return this;
        }

        public Builder partner_quote(YesNo val) {
            partner_quote = val;
            return this;
        }

        public Builder company(String val) {
            company = val;
            return this;
        }

        public Builder partnerBrand(String val) {
            partnerBrand = val;
            return this;
        }

        public Builder lead_number(String val) {
            lead_number = val;
            return this;
        }

        public LifeApplyPostRequestPayload build() {
            return new LifeApplyPostRequestPayload(this);
        }
    }
}
