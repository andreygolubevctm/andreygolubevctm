package com.ctm.web.core.model.formData;

public class RequestImpl implements Request {

    private String clientIpAddress;

    private Long transactionId;

    private String environmentOverride;

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }
}
