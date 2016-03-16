package com.ctm.web.energy.form.model;

import com.ctm.web.core.model.formData.RequestImpl;

import javax.validation.constraints.NotNull;

public class EnergyProductInfoWebRequest extends RequestImpl {

    @NotNull
    private String productId;

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String toString() {
        return "EnergyProductInfoWebRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", productId=" + productId +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
