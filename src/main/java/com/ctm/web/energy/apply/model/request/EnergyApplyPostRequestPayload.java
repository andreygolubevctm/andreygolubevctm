package com.ctm.web.energy.apply.model.request;

import com.ctm.web.core.model.formData.Request;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyApplyPostRequestPayload implements Request {
    private Long transactionId;
    private String clientIpAddress;
    private String environmentOverride;
    private EnergyApplicationPayload utilities;
    private Current current;

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

    public EnergyApplicationPayload getUtilities() {
        return utilities;
    }

    public void setUtilities(EnergyApplicationPayload utilities) {
        this.utilities = utilities;
    }

    public Current getCurrent() {
        return current;
    }
}
