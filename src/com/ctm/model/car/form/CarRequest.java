package com.ctm.model.car.form;

import com.ctm.model.Request;

public class CarRequest implements Request<CarQuote> {

    private String clientIpAddress;

    private CarQuote quote;

    private String transactionId;

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
    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
}
