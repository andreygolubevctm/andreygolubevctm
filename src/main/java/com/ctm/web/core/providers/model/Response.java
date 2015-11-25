package com.ctm.web.core.providers.model;

import java.util.List;

public class Response<T> {

    public long transactionId;

    public QuoteResponse<T> payload;

    public List<ResponseError> errors;

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

    public List<ResponseError> getErrors() {
        return errors;
    }

    public void setErrors(List<ResponseError> errors) {
        this.errors = errors;
    }
}
