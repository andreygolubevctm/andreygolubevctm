package com.ctm.web.car.quote.model.response;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
public class CarQuote {

    public boolean available;

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

    private String excess;

    private String glassExcess;

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

    private String followupIntended;

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getService() {
        return service;
    }

    public String getProductId() {
        return productId;
    }

    public void setService(String service) {
        this.service = service;
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

    public List<ProductDisclosure> getProductDisclosures() {
        return productDisclosures;
    }

    public void setProductDisclosures(List<ProductDisclosure> productDisclosures) {
        this.productDisclosures = productDisclosures;
    }

    public String getDisclaimer() {
        return disclaimer;
    }

    public void setDisclaimer(String disclaimer) {
        this.disclaimer = disclaimer;
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

    public List<String> getSpecialConditions() {
        return specialConditions;
    }

    public void setSpecialConditions(List<String> specialConditions) {
        this.specialConditions = specialConditions;
    }

    public String getExcess() {
        return excess;
    }

    public void setExcess(String excess) {
        this.excess = excess;
    }

    public String getGlassExcess() { return glassExcess; }

    public void setGlassExcess(String glassExcess) { this.glassExcess = glassExcess; }

    public List<AdditionalExcess> getAdditionalExcesses() {
        return additionalExcesses;
    }

    public void setAdditionalExcesses(List<AdditionalExcess> additionalExcesses) {
        this.additionalExcesses = additionalExcesses;
    }

    public boolean isAvailableOnline() {
        return availableOnline;
    }

    public void setAvailableOnline(boolean availableOnline) {
        this.availableOnline = availableOnline;
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

    public String getFollowupIntended() {
        return followupIntended;
    }

    public void setFollowupIntended(final String followupIntended) {
        this.followupIntended = followupIntended;
    }
}
