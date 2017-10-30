package com.ctm.web.health.quote.model.request;

import java.util.List;

public class Filters {

    private CappingLimit cappingLimitFilter;

    private ExcessFilter excessFilter;

    private ProviderFilter providerFilter;

    private PriceFilter priceFilter;

    private Integer tierHospitalFilter;

    private Integer tierExtrasFilter;

    private ProductTitleFilter productTitleFilter;

    private List<String> preferencesFilter;

    private CompareResultsFilter compareResultsFilter;

    private IncludeProductIfNotFound includeProductIfNotFound;

    private Boolean situationFilter;

    private Boolean applyDiscounts;

    private Boolean popularProducts;

    public CappingLimit getCappingLimitFilter() {
        return cappingLimitFilter;
    }

    public void setCappingLimitFilter(CappingLimit cappingLimitFilter) {
        this.cappingLimitFilter = cappingLimitFilter;
    }

    public ExcessFilter getExcessFilter() {
        return excessFilter;
    }

    public void setExcessFilter(ExcessFilter excessFilter) {
        this.excessFilter = excessFilter;
    }

    public ProviderFilter getProviderFilter() {
        return providerFilter;
    }

    public void setProviderFilter(ProviderFilter providerFilter) {
        this.providerFilter = providerFilter;
    }

    public PriceFilter getPriceFilter() {
        return priceFilter;
    }

    public void setPriceFilter(PriceFilter priceFilter) {
        this.priceFilter = priceFilter;
    }

    public Integer getTierHospitalFilter() {
        return tierHospitalFilter;
    }

    public void setTierHospitalFilter(Integer tierHospitalFilter) {
        this.tierHospitalFilter = tierHospitalFilter;
    }

    public Integer getTierExtrasFilter() {
        return tierExtrasFilter;
    }

    public void setTierExtrasFilter(Integer tierExtrasFilter) {
        this.tierExtrasFilter = tierExtrasFilter;
    }

    public ProductTitleFilter getProductTitleFilter() {
        return productTitleFilter;
    }

    public void setProductTitleFilter(ProductTitleFilter productTitleFilter) {
        this.productTitleFilter = productTitleFilter;
    }

    public List<String> getPreferencesFilter() {
        return preferencesFilter;
    }

    public void setPreferencesFilter(List<String> preferencesFilter) {
        this.preferencesFilter = preferencesFilter;
    }

    public CompareResultsFilter getCompareResultsFilter() {
        return compareResultsFilter;
    }

    public void setCompareResultsFilter(CompareResultsFilter compareResultsFilter) {
        this.compareResultsFilter = compareResultsFilter;
    }

    public IncludeProductIfNotFound getIncludeProductIfNotFound() {
        return includeProductIfNotFound;
    }

    public void setIncludeProductIfNotFound(IncludeProductIfNotFound includeProductIfNotFound) {
        this.includeProductIfNotFound = includeProductIfNotFound;
    }

    public Boolean getSituationFilter() {
        return situationFilter;
    }

    public void setSituationFilter(Boolean situationFilter) {
        this.situationFilter = situationFilter;
    }

    public Boolean getApplyDiscounts() {
        return applyDiscounts;
    }

    public void setApplyDiscounts(Boolean applyDiscounts) {
        this.applyDiscounts = applyDiscounts;
    }

    public Boolean getPopularProducts() {
        return popularProducts;
    }

    public void setPopularProducts(Boolean popularProducts) {
        this.popularProducts = popularProducts;
    }
}
