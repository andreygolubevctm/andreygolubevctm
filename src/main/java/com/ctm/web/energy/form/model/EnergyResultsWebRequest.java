package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.Request;


public class EnergyResultsWebRequest implements Request<EnergyResultsRequestModel> {
    private String clientIpAddress;

    private EnergyResultsRequestModel quote;

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
    public EnergyResultsRequestModel getQuote() {
        return quote;
    }

    public void setQuote(EnergyResultsRequestModel quote) {
        this.quote = quote;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
