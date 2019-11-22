package com.ctm.web.health.quote.model.response;

import com.fasterxml.jackson.databind.JsonNode;

import java.util.Map;

public class Info {

    private boolean restrictedFund;

    private String fundName;

    private String fundCode;

    private Integer providerId;

    private String productCode;

    private String hospitalName;

    private String extrasName;

    private String fundProductCode;

    private String title;

    private String name;

    private String description;

    private Integer rank;

    private Integer popularProductRank;

    private JsonNode otherProductFeatures;

    private Map<String, String> otherInfoProperties;

    private String situationFilter;

    private Boolean popularProduct;

    private String abdRequestFlag;

    private int excess;

    public boolean isRestrictedFund() {
        return restrictedFund;
    }

    public void setRestrictedFund(boolean restrictedFund) {
        this.restrictedFund = restrictedFund;
    }

    public String getFundName() {
        return fundName;
    }

    public void setFundName(String fundName) {
        this.fundName = fundName;
    }

    public String getFundCode() {
        return fundCode;
    }

    public void setFundCode(String fundCode) {
        this.fundCode = fundCode;
    }

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName;
    }

    public String getExtrasName() {
        return extrasName;
    }

    public void setExtrasName(String extrasName) {
        this.extrasName = extrasName;
    }

    public String getFundProductCode() {
        return fundProductCode;
    }

    public void setFundProductCode(String fundProductCode) {
        this.fundProductCode = fundProductCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getRank() {
        return rank;
    }

    public void setRank(Integer rank) {
        this.rank = rank;
    }

    public JsonNode getOtherProductFeatures() {
        return otherProductFeatures;
    }

    public void setOtherProductFeatures(JsonNode otherProductFeatures) {
        this.otherProductFeatures = otherProductFeatures;
    }

    public Map<String, String> getOtherInfoProperties() {
        return otherInfoProperties;
    }

    public void setOtherInfoProperties(Map<String, String> otherInfoProperties) {
        this.otherInfoProperties = otherInfoProperties;
    }

    public String getSituationFilter() {
        return situationFilter;
    }

    public void setSituationFilter(String situationFilter) {
        this.situationFilter = situationFilter;
    }

    public Boolean getPopularProduct() {
        return popularProduct;
    }

    public void setPopularProduct(Boolean popularProduct) {
        this.popularProduct = popularProduct;
    }

    public Integer getPopularProductRank() {
        return popularProductRank;
    }

    public void setPopularProductRank(Integer popularProductRank) {
        this.popularProductRank = popularProductRank;
    }

    public String getAbdRequestFlag() {
        return abdRequestFlag;
    }

    public void setAbdRequestFlag(String abdRequestFlag) {
        this.abdRequestFlag = abdRequestFlag;
    }

    public int getExcess() {
        return excess;
    }

    public void setExcess(int excess) {
        this.excess = excess;
    }
}
