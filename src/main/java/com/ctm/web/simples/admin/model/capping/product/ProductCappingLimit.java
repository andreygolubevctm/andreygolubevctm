package com.ctm.web.simples.admin.model.capping.product;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.time.LocalDate;

public class ProductCappingLimit {
    private Integer providerId;
    private Integer cappingLimitId;
    private String productCode;
    private String productName;
    private String state;
    private String healthCvr;
    private String limitType;
    private Integer cappingAmount;
    private Integer currentJoinCount;
    private LocalDate effectiveStart;
    private LocalDate effectiveEnd;
    private String cappingLimitCategory;
    private Boolean current;

    public ProductCappingLimit(Integer providerId, Integer cappingLimitId, String productCode, String productName, String state, String healthCvr, String limitType, Integer cappingAmount, Integer currentJoinCount, LocalDate effectiveStart, LocalDate effectiveEnd, String cappingLimitCategory, Boolean current) {
        this.providerId = providerId;
        this.cappingLimitId = cappingLimitId;
        this.productCode = productCode;
        this.productName = productName;
        this.state = state;
        this.healthCvr = healthCvr;
        this.limitType = limitType;
        this.cappingAmount = cappingAmount;
        this.currentJoinCount = currentJoinCount;
        this.effectiveStart = effectiveStart;
        this.effectiveEnd = effectiveEnd;
        this.cappingLimitCategory = cappingLimitCategory;
        this.current = current;

    }

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public Integer getCappingLimitId() {
        return cappingLimitId;
    }

    public String getProductCode() {
        return productCode;
    }

    public String getState() {
        return state;
    }

    public String getHealthCvr() {
        return healthCvr;
    }

    public String getProductName() {
        return productName;
    }

    public String getLimitType() {
        return limitType;
    }

    public Integer getCappingAmount() {
        return cappingAmount;
    }

    public Integer getCurrentJoinCount() {
        return currentJoinCount;
    }

    @JsonSerialize(using = LocalDateSerializer.class)
    public LocalDate getEffectiveStart() {
        return effectiveStart;
    }

    @JsonSerialize(using = LocalDateSerializer.class)
    public LocalDate getEffectiveEnd() {
        return effectiveEnd;
    }

    public String getCappingLimitCategory() {
        return cappingLimitCategory;
    }

    public Boolean getCurrent() {
        return current;
    }

    public void setCappingLimitId(Integer cappingLimitId) {
        this.cappingLimitId = cappingLimitId;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setHealthCvr(String healthCvr) {
        this.healthCvr = healthCvr;
    }

    public void setLimitType(String limitType) {
        this.limitType = limitType;
    }

    public void setCappingAmount(Integer cappingAmount) {
        this.cappingAmount = cappingAmount;
    }

    public void setCurrentJoinCount(Integer currentJoinCount) {
        this.currentJoinCount = currentJoinCount;
    }

    public void setEffectiveStart(LocalDate effectiveStart) {
        this.effectiveStart = effectiveStart;
    }

    public void setEffectiveEnd(LocalDate effectiveEnd) {
        this.effectiveEnd = effectiveEnd;
    }

    public void setCappingLimitCategory(String cappingLimitCategory) {
        this.cappingLimitCategory = cappingLimitCategory;
    }

    public void setCurrent(Boolean current) {
        this.current = current;
    }
}
