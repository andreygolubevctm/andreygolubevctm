package com.ctm.web.simples.admin.model.capping.product;

public class HealthProductProviderSummary {
    private Integer providerId;
    private String providerName;
    private String providerCode;
    private Integer currentProductCapCount;

    public HealthProductProviderSummary(Integer providerId, String providerName, String providerCode, Integer currentProductCapCount) {
        this.providerId = providerId;
        this.providerName = providerName;
        this.providerCode = providerCode;
        this.currentProductCapCount = currentProductCapCount;
    }

    public Integer getProviderId() {
        return providerId;
    }

    public String getProviderName() {
        return providerName;
    }

    public String getProviderCode() {
        return providerCode;
    }

    public Integer getCurrentProductCapCount() {
        return currentProductCapCount;
    }
}
