package com.ctm.model.travel.form;

import com.ctm.model.Request;

public class TravelRequest implements Request<TravelQuote> {

    private String clientIpAddress;

    private TravelQuote quote;

    private Long transactionId;

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public TravelQuote getQuote() {
        return quote;
    }

    public void setQuote(TravelQuote quote) {
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
