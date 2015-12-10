package com.ctm.web.energy.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyApplyPostReqestPayload implements Request {
    private Long transactionId;
    private String clientIpAddress;
    private String environmentOverride;
    private EnergyApplicationPayload utilities;

    private EnergyApplyPostReqestPayload(){

    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }


    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    public EnergyApplicationPayload getUtilities() {
        return utilities;
    }
}
