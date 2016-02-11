package com.ctm.web.health.model.form;

import com.ctm.web.core.model.formData.RequestImpl;

public class HealthAuthorisePaymentRequest extends RequestImpl {

    private String providerId;

    private String returnUrl;

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String toString() {
        return "HealthAuthorisePaymentRequest{" +
                "transactionId=" + getTransactionId() +
                ", clientIpAddress='" + getClientIpAddress() + '\'' +
                ", providerId=" + getProviderId() +
                ", returnUrl=" + getReturnUrl() +
                ", environmentOverride='" + getEnvironmentOverride() + '\'' +
                ", requestAt='" +getRequestAt() + '\'' +
                '}';
    }
}
