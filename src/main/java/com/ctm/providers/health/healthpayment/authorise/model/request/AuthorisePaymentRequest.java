package com.ctm.providers.health.healthpayment.authorise.model.request;

import java.util.List;

public class AuthorisePaymentRequest {

    private String returnUrl;

    private List<String> providerFilter;

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public List<String> getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(List<String> providerFilter) {
        this.providerFilter = providerFilter;
    }
}
