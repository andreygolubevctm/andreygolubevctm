package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.Request;

import javax.validation.constraints.NotNull;

public class EnergyProductInfoWebRequest implements Request {

    private String clientIpAddress;

    private Long transactionId;

    private String environmentOverride;

    @NotNull
    private String productId;

    @Override
    public String getClientIpAddress() {
        return clientIpAddress;
    }

    @Override
    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    @Override
    public Long getTransactionId() {
        return transactionId;
    }

    @Override
    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    @Override
    public String getEnvironmentOverride() {
        return environmentOverride;
    }

    @Override
    public void setEnvironmentOverride(String environmentOverride) {
        this.environmentOverride = environmentOverride;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }
}
