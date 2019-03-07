package com.ctm.web.health.quote.model.request;

import com.ctm.web.health.model.HospitalSelection;
import com.ctm.web.health.model.Membership;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.ProductStatus;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class HealthQuoteRequest {

    private boolean isSimples;

    private String state;

    private Membership membership;

    private ProductType productType;

    private Integer loading;

    private HospitalSelection hospitalSelection;

    private List<ProductStatus> excludeStatus;

    private Filters filters;

    @JsonSerialize(using = LocalDateSerializer.class)
    private LocalDate searchDateValue;

    private int searchResults = 12;

    private boolean includeAlternativePricing;

    private boolean includeGiftCard;

    private Boolean primaryHealthCover;

    private Boolean partnerHealthCover;

    private Integer age;

    private String familyType;

    private String productCode;

    /**
     * Use rebates
     */
    @Deprecated
    private BigDecimal rebate;

    private Rebates rebates;

    private Boolean includeSummary;

    private List<PaymentType> paymentTypes;

    private int abdPercentage;
    private int rabdPercentage;

    private AbdSummary abdSummary;

    public boolean getIsSimples() {
        return isSimples;
    }

    public void setIsSimples(boolean isSimples) {
        this.isSimples = isSimples;
    }

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

    public ProductType getProductType() {
        return productType;
    }

    public void setProductType(ProductType productType) {
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

    public boolean isIncludeGiftCard() {
        return includeGiftCard;
    }

    public void setIncludeGiftCard(final boolean includeGiftCard) {
        this.includeGiftCard = includeGiftCard;
    }

    public BigDecimal getRebate() {
        return rebate;
    }

    public void setRebate(BigDecimal rebate) {
        this.rebate = rebate;
    }

    public Rebates getRebates() {
        return rebates;
    }

    public void setRebates(final Rebates rebates) {
        this.rebates = rebates;
    }

    public List<PaymentType> getPaymentTypes() {
        return paymentTypes;
    }

    public void setPaymentTypes(List<PaymentType> paymentTypes) {
        this.paymentTypes = paymentTypes;
    }

    public Boolean getIncludeSummary() {
        return includeSummary;
    }

    public void setIncludeSummary(Boolean includeSummary) {
        this.includeSummary = includeSummary;
    }

    public Boolean isPrimaryHealthCover() {
        return primaryHealthCover;
    }

    public void setPrimaryHealthCover(Boolean primaryHealthCover) {
        this.primaryHealthCover = primaryHealthCover;
    }

    public Boolean isPartnerHealthCover() {
        return partnerHealthCover;
    }

    public void setPartnerHealthCover(Boolean partnerHealthCover) {
        this.partnerHealthCover = partnerHealthCover;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getFamilyType() {
        return familyType;
    }

    public void setFamilyType(String familyType) {
        this.familyType = familyType;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public void setAbdPercentage(int abdPercentage) {
        this.abdPercentage = abdPercentage;
    }

    public int getAbdPercentage() {
        return abdPercentage;
    }

    public int getRabdPercentage() {
        return rabdPercentage;
    }

    public void setRabdPercentage(int rabdPercentage) {
        this.rabdPercentage = rabdPercentage;
    }

    public AbdSummary getAbdSummary() {
        return abdSummary;
    }

    public void setAbdSummary(AbdSummary abdSummary) {
        this.abdSummary = abdSummary;
    }
}
