package com.ctm.web.energy.form.model;

import com.ctm.web.core.providers.model.Response;


public class EnergyResultsWebResponse extends Response {
    private String clientIpAddress;

    private EnergyResultsRequestModel quote;

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

    public EnergyResultsRequestModel getQuote() {
        return quote;
    }

    public void setQuote(EnergyResultsRequestModel quote) {
        this.quote = quote;
    }


    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
