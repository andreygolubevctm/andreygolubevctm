package com.ctm.web.core.providers.model;


public class IncomingApplyResponse<T> {

    public long transactionId;

    public T payload;

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public T getPayload() {
        return payload;
    }

    public void setPayload(T payload) {
        this.payload = payload;
    }
}
