package com.ctm.web.simples.admin.model.capping.product;

import org.hibernate.validator.constraints.Range;

import java.time.LocalDate;

public class UpdateProductCappingLimitDTO {
    @Range(min = 1, message = "Capping Limit ID must be positive Integer")
    private Integer cappingLimitId;
    private String limitType;
    private Integer cappingAmount;
    private String cappingLimitCategory;
    private LocalDate effectiveStart;
    private LocalDate effectiveEnd;

    public Integer getCappingLimitId() {
        return cappingLimitId;
    }

    public void setCappingLimitId(Integer cappingLimitId) {
        this.cappingLimitId = cappingLimitId;
    }

    public String getLimitType() {
        return limitType;
    }

    public void setLimitType(String limitType) {
        this.limitType = limitType;
    }

    public Integer getCappingAmount() {
        return cappingAmount;
    }

    public void setCappingAmount(Integer cappingAmount) {
        this.cappingAmount = cappingAmount;
    }

    public String getCappingLimitCategory() {
        return cappingLimitCategory;
    }

    public void setCappingLimitCategory(String cappingLimitCategory) {
        this.cappingLimitCategory = cappingLimitCategory;
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
