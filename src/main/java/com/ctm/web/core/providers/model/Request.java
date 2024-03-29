package com.ctm.web.core.providers.model;

import java.time.LocalDateTime;

public class Request<T> {

    public String brandCode;

    public long transactionId;

    public String clientIp;

    public LocalDateTime requestAt;

    public T payload;

    public String getBrandCode() {
        return brandCode;
    }

    public void setBrandCode(String brandCode) {
        this.brandCode = brandCode;
    }

    public long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(long transactionId) {
        this.transactionId = transactionId;
    }

    public String getClientIp() {
        return clientIp;
    }

    public void setClientIp(String clientIp) {
        this.clientIp = clientIp;
    }

    public T getPayload() {
        return payload;
    }

    public void setPayload(T payload) {
        this.payload = payload;
    }

    public LocalDateTime getRequestAt() {
        return requestAt;
    }

    public void setRequestAt(LocalDateTime requestAt) {
        this.requestAt = requestAt;
    }
}
