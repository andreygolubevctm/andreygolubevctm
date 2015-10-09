package com.ctm.providers.health.healthquote.model.request;

import com.ctm.model.health.HospitalSelection;
import com.ctm.model.health.Membership;
import com.ctm.model.health.ProductStatus;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class HealthQuoteRequest
{

    private String state;

    private Membership membership;

    private String productType;

    private Integer loading;

    private HospitalSelection hospitalSelection;

    private List<ProductStatus> excludeStatus;

    private Filters filters;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate searchDateValue;

    private int searchResults = 12;

    private boolean includeAlternativePricing;

    private BigDecimal rebate;

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public Membership getMembership() {
        return membership;
    }

    public void setMembership(Membership membership) {
        this.membership = membership;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Integer getLoading() {
        return loading;
    }

    public void setLoading(Integer loading) {
        this.loading = loading;
    }

    public HospitalSelection getHospitalSelection() {
        return hospitalSelection;
    }

    public void setHospitalSelection(HospitalSelection hospitalSelection) {
        this.hospitalSelection = hospitalSelection;
    }

    public List<ProductStatus> getExcludeStatus() {
        return excludeStatus;
    }

    public void setExcludeStatus(List<ProductStatus> excludeStatus) {
        this.excludeStatus = excludeStatus;
    }

    public Filters getFilters() {
        return filters;
    }

    public void setFilters(Filters filters) {
        this.filters = filters;
    }

    public LocalDate getSearchDateValue() {
        return searchDateValue;
    }

    public void setSearchDateValue(LocalDate searchDateValue) {
        this.searchDateValue = searchDateValue;
    }

    public int getSearchResults() {
        return searchResults;
    }

    public void setSearchResults(int searchResults) {
        this.searchResults = searchResults;
    }

    public boolean isIncludeAlternativePricing() {
        return includeAlternativePricing;
    }

    public void setIncludeAlternativePricing(boolean includeAlternativePricing) {
        this.includeAlternativePricing = includeAlternativePricing;
    }

    public BigDecimal getRebate() {
        return rebate;
    }

    public void setRebate(BigDecimal rebate) {
        this.rebate = rebate;
    }
}
