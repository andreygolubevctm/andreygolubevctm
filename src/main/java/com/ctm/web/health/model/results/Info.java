package com.ctm.web.health.model.results;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;

import java.io.Serializable;

public class Info implements Serializable {

    private String trackCode;

    @JsonProperty("Category")
    private String category;

    @JsonProperty("ProductType")
    private String productType;

    private String restrictedFund;

    private String productTitle;

    private String productCode;

    private String hospitalName;

    private String extrasName;

    private String fundProductCode;

    private String des;

    @JsonProperty("FundCode")
    private String fundCode;

    private String provider;

    private Integer providerId;

    @JsonProperty("State")
    private String state;

    private String name;

    private Integer rank;

    private Integer popularProductsRank;

    private String providerName;

    @JsonProperty("OtherProductFeatures")
    private JsonNode otherProductFeatures;

    private String situationFilter;

    private Boolean popularProduct;

    private String abdRequestFlag;

    private int excess;

    public String getTrackCode() {
        return trackCode;
    }

    public void setTrackCode(String trackCode) {
        this.trackCode = trackCode;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getRestrictedFund() {
        return restrictedFund;
    }

    public void setRestrictedFund(String restrictedFund) {
        this.restrictedFund = restrictedFund;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
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

    public String getDes() {
        return des;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public String getFundCode() {
        return fundCode;
    }

    public void setFundCode(String fundCode) {
        this.fundCode = fundCode;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public Integer getProviderId() {
        return providerId;
    }

    public void setProviderId(Integer providerId) {
        this.providerId = providerId;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getRank() {
        return rank;
    }

    public void setRank(Integer rank) {
        this.rank = rank;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public JsonNode getOtherProductFeatures() {
        return otherProductFeatures;
    }

    public void setOtherProductFeatures(JsonNode otherProductFeatures) {
        this.otherProductFeatures = otherProductFeatures;
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

    public Integer getPopularProductsRank() {
        return popularProductsRank;
    }

    public void setPopularProductsRank(Integer popularProductsRank) {
        this.popularProductsRank = popularProductsRank;
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
