package com.ctm.web.core.providers.model;


public class Response<T> {

    public long transactionId;

    public QuoteResponse<T> payload;

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public QuoteResponse<T> getPayload() {
        return payload;
    }

    public void setPayload(QuoteResponse<T> payload) {
        this.payload = payload;
    }
}
