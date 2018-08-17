package com.ctm.web.simples.admin.model.capping.product;

import java.time.LocalDate;

public class CreateProductCappingLimitDTO {
    private Integer providerId;
    private String productName;
    private String state;
    private String healthCvr;
    private String limitType;
    private String cappingAmount;
    private String cappingLimitCategory;
    private LocalDate effectiveStart;
    private LocalDate effectiveEnd;

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getHealthCvr() {
        return healthCvr;
    }

    public void setHealthCvr(String healthCvr) {
        this.healthCvr = healthCvr;
    }

    public String getLimitType() {
        return limitType;
    }

    public void setLimitType(String limitType) {
        this.limitType = ProductCappingLimitType.fromString(limitType).map(p -> p.text).orElse(null);
    }

    public String getCappingAmount() {
        return cappingAmount;
    }

    public void setCappingAmount(String cappingAmount) {
        this.cappingAmount = cappingAmount;
    }

    public String getCappingLimitCategory() {
        return cappingLimitCategory;
    }

    public void setCappingLimitCategory(String cappingLimitCategory) {
        this.cappingLimitCategory = ProductCappingLimitCategory.fromString(cappingLimitCategory).map(p -> p.text).orElse(null);
    }

    public LocalDate getEffectiveStart() {
        return effectiveStart;
    }

    public void setEffectiveStart(LocalDate effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public LocalDate getEffectiveEnd() {
        return effectiveEnd;
    }

    public void setEffectiveEnd(LocalDate effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }
}
