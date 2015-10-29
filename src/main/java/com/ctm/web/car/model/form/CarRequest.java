package com.ctm.web.car.model.form;

import com.ctm.model.formData.Request;

public class CarRequest implements Request<CarQuote> {

    private String clientIpAddress;

    private CarQuote quote;

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
    public CarQuote getQuote() {
        return quote;
    }

    public void setQuote(CarQuote quote) {
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
