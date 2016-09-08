package com.ctm.web.health.payment.authorise.model.request;

public class AuthorisePaymentRequest {

    private String returnUrl;

    private String providerFilter;

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(String providerFilter) {
        this.providerFilter = providerFilter;
    }
}
