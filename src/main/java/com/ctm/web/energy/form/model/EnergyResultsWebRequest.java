package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.Request;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


@JsonIgnoreProperties(ignoreUnknown = true)
public class EnergyResultsWebRequest implements Request {

    public EnergyResultsWebRequest(){

    }

    private String clientIpAddress;

    private EnergyPayLoad utilities;

    private Long transactionId;

    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    private String environmentOverride;

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public EnergyPayLoad getUtilities() {
        return utilities;
    }

    public void setUtilities(EnergyPayLoad utilities) {
        this.utilities = utilities;
    }
}
