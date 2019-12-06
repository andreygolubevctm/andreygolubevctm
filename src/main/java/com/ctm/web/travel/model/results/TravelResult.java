package com.ctm.web.travel.model.results;

import com.ctm.web.core.resultsData.model.Result;

import java.math.BigDecimal;
import java.util.ArrayList;

/**
 * Java model which will build the travel result sent to the front end.
 * This model is converted to JSON.
 */
public class TravelResult extends Result {

    private String trackCode;
    private String productId;
    private String quoteUrl;
    private String infoDes;
    private String des;
    private String subTitle;
    private String service;
    private BigDecimal price;
    private String name;
    private String priceText;
    private String encodeUrl;
    private String handoverUrl;
    private String handoverType;
    private String handoverVar;
    private String handoverData;
    private ArrayList<Benefit> benefits;
    private ArrayList<ExemptedBenefit> exemptedBenefits;
    private Info info;
    private Boolean isDomestic;
    private Offer offer;
    private Boolean medicalCondsAssessed;
    private String providerName;

    public TravelResult(){
        benefits = new ArrayList<Benefit>();
        exemptedBenefits = new ArrayList<ExemptedBenefit>();
    }

    public String getTrackCode() {
        return trackCode;
    }

    public void setTrackCode(String trackCode) {
        this.trackCode = trackCode;
    }

    public void setProviderName(String providerName){
        this.providerName = providerName;
    }
    public String getProviderName() {
        return providerName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getQuoteUrl() {
        return quoteUrl;
    }

    public void setQuoteUrl(String quoteUrl) {
        this.quoteUrl = quoteUrl;
    }

    public String getInfoDes() {
        return infoDes;
    }

    public void setInfoDes(String infoDes) {
        this.infoDes = infoDes;
    }

    public String getDes() {
        return des;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPriceText() {
        return priceText;
    }

    public void setPriceText(String priceText) {
        this.priceText = priceText;
    }

    public String getEncodeUrl() {
        return encodeUrl;
    }

    public void setEncodeUrl(String encodeUrl) {
        this.encodeUrl = encodeUrl;
    }

    public ArrayList<Benefit> getBenefits() {
        return benefits;
    }

    public void setBenefits(ArrayList<Benefit> benefits) {
        this.benefits = benefits;
    }

    public void addBenefit(Benefit benefit){
        benefits.add(benefit);
    }

    public void addExemptedBenefit(ExemptedBenefit benefit){
        exemptedBenefits.add(benefit);
    }

    public String getHandoverUrl() {
        return handoverUrl;
    }

    public void setHandoverUrl(String handoverUrl) {
        this.handoverUrl = handoverUrl;
    }

    public String getHandoverType() {
        return handoverType;
    }

    public void setHandoverType(String handoverType) {
        this.handoverType = handoverType;
    }

    public String getHandoverVar() {
        return handoverVar;
    }

    public void setHandoverVar(String handoverVar) {
        this.handoverVar = handoverVar;
    }

    public String getHandoverData() {
        return handoverData;
    }

    public void setHandoverData(String handoverData) {
        this.handoverData = handoverData;
    }

    public ArrayList<ExemptedBenefit> getExemptedBenefits() {
        return exemptedBenefits;
    }

    public void setExemptedBenefits(ArrayList<ExemptedBenefit> exemptedBenefits) {
        this.exemptedBenefits = exemptedBenefits;
    }

    public Boolean getIsDomestic() { return isDomestic; }
    public void setIsDomestic(Boolean isDomestic) { this.isDomestic = isDomestic; }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }

    public Offer getOffer() {
        return offer;
    }

    public void setOffer(Offer offer) {
        this.offer = offer;
    }

    public Boolean getMedicalCondsAssessed() { return medicalCondsAssessed; }

    public void setMedicalCondsAssessed(Boolean medicalCondsAssessed) { this.medicalCondsAssessed = medicalCondsAssessed; }
}
