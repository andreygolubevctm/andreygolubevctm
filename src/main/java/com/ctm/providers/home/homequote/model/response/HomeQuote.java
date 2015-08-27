package com.ctm.providers.home.homequote.model.response;

import java.util.List;

public class HomeQuote {

    public boolean available = true;

    private String service;

    private String productId;

    private String providerProductName;

    private String brandCode;

    private String quoteNumber;

    private String quoteUrl;

    private String productName;

    private String productDescription;

    private String discountOffer;

    private String discountOfferTerms;

    private boolean availableOnline;

    private List<String> specialConditions;

    private Excess contentsExcess;

    private Excess homeExcess;

    private Discount discount;

    private Contact contact;

    private Price price;

    private List<AdditionalExcess> additionalExcesses;

    private List<Feature> features;

    private Underwriter underwriter;

    private String disclaimer;

    private List<ProductDisclosure> productDisclosures;

    private String inclusions;

    private String benefits;

    private String optionalExtras;

    private String vdn;

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProviderProductName() {
        return providerProductName;
    }

    public void setProviderProductName(String providerProductName) {
        this.providerProductName = providerProductName;
    }

    public String getBrandCode() {
        return brandCode;
    }

    public void setBrandCode(String brandCode) {
        this.brandCode = brandCode;
    }

    public String getQuoteNumber() {
        return quoteNumber;
    }

    public void setQuoteNumber(String quoteNumber) {
        this.quoteNumber = quoteNumber;
    }

    public String getQuoteUrl() {
        return quoteUrl;
    }

    public void setQuoteUrl(String quoteUrl) {
        this.quoteUrl = quoteUrl;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getDiscountOffer() {
        return discountOffer;
    }

    public void setDiscountOffer(String discountOffer) {
        this.discountOffer = discountOffer;
    }

    public String getDiscountOfferTerms() {
        return discountOfferTerms;
    }

    public void setDiscountOfferTerms(String discountOfferTerms) {
        this.discountOfferTerms = discountOfferTerms;
    }

    public boolean isAvailableOnline() {
        return availableOnline;
    }

    public void setAvailableOnline(boolean availableOnline) {
        this.availableOnline = availableOnline;
    }

    public List<String> getSpecialConditions() {
        return specialConditions;
    }

    public void setSpecialConditions(List<String> specialConditions) {
        this.specialConditions = specialConditions;
    }

    public Excess getContentsExcess() {
        return contentsExcess;
    }

    public void setContentsExcess(Excess contentsExcess) {
        this.contentsExcess = contentsExcess;
    }

    public Excess getHomeExcess() {
        return homeExcess;
    }

    public void setHomeExcess(Excess homeExcess) {
        this.homeExcess = homeExcess;
    }

    public Discount getDiscount() {
        return discount;
    }

    public void setDiscount(Discount discount) {
        this.discount = discount;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Price getPrice() {
        return price;
    }

    public void setPrice(Price price) {
        this.price = price;
    }

    public List<AdditionalExcess> getAdditionalExcesses() {
        return additionalExcesses;
    }

    public void setAdditionalExcesses(List<AdditionalExcess> additionalExcesses) {
        this.additionalExcesses = additionalExcesses;
    }

    public List<Feature> getFeatures() {
        return features;
    }

    public void setFeatures(List<Feature> features) {
        this.features = features;
    }

    public Underwriter getUnderwriter() {
        return underwriter;
    }

    public void setUnderwriter(Underwriter underwriter) {
        this.underwriter = underwriter;
    }

    public String getDisclaimer() {
        return disclaimer;
    }

    public void setDisclaimer(String disclaimer) {
        this.disclaimer = disclaimer;
    }

    public List<ProductDisclosure> getProductDisclosures() {
        return productDisclosures;
    }

    public void setProductDisclosures(List<ProductDisclosure> productDisclosures) {
        this.productDisclosures = productDisclosures;
    }

    public String getInclusions() {
        return inclusions;
    }

    public void setInclusions(String inclusions) {
        this.inclusions = inclusions;
    }

    public String getBenefits() {
        return benefits;
    }

    public void setBenefits(String benefits) {
        this.benefits = benefits;
    }

    public String getOptionalExtras() {
        return optionalExtras;
    }

    public void setOptionalExtras(String optionalExtras) {
        this.optionalExtras = optionalExtras;
    }

    public String getVdn() {
        return vdn;
    }

    public void setVdn(String vdn) {
        this.vdn = vdn;
    }
}
