package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.RequestWithQuote;

public class HealthRequest implements RequestWithQuote<HealthQuote> {

    private String clientIpAddress;

    private HealthQuote health;

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

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public HealthQuote getQuote() {
        return health;
    }

    public HealthQuote getHealth() {
        return health;
    }

    public void setHealth(HealthQuote health) {
        this.health = health;
    }

    public void setQuote(HealthQuote quote) {
        this.health = quote;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }
}
