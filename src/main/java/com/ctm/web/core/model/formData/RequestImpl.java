package com.ctm.web.core.model.formData;

import java.time.LocalDateTime;

public abstract class RequestImpl implements Request {

    private String clientIpAddress;

    private String environmentOverride;

    private String staticOverride;

    private Long transactionId;

    private LocalDateTime requestAt;

    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    public String getStaticOverride() {
        return staticOverride;
    }

    public void setStaticOverride(String staticOverride) {
        this.staticOverride = staticOverride;
    }

    public LocalDateTime getRequestAt() {
        return requestAt;
    }

    public void setRequestAt(LocalDateTime requestAt) {
        this.requestAt = requestAt;
    }
}
