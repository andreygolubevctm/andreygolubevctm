package com.ctm.web.travel.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class TravelRequest implements RequestWithQuote<TravelQuote> {

    private String clientIpAddress;
    private TravelQuote travel;
    private Long transactionId;
    private String environmentOverride;

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public TravelQuote getQuote() {
        return travel;
    }

    public void setTravel(TravelQuote quote) {
        this.travel = quote;
    }

    public TravelQuote getTravel() {
        return travel;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    @Override
    public String toString() {
        return "TravelRequest{" +
                "clientIpAddress='" + clientIpAddress + '\'' +
                ", travel=" + travel +
                ", transactionId=" + transactionId +
                ", environmentOverride='" + environmentOverride + '\'' +
                '}';
    }
}
