package com.ctm.web.car.model.results;

import com.ctm.web.core.resultsData.model.Result;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

public class CarResult extends Result {

    private String providerProductName;

    private String brandCode;

    private String quoteNumber;

    private String quoteUrl;

    private String productName;

    private String productDescription;

    private String discountOffer;

    private String discountOfferTerms;

    private boolean availableOnline;

    @JsonSerialize(using = SpecialConditionsSerializer.class)
    private List<String> specialConditions;

    @JsonSerialize(using = ExcessSerializer.class)
    private Excess excesses;

    @JsonSerialize(using = AdditionalExcessesSerializer.class)
    private List<AdditionalExcess> additionalExcesses;

    private Contact contact;

    private Price price;

    @JsonSerialize(using = FeaturesSerializer.class)
    private List<Feature> features;

    private Underwriter underwriter;

    private String disclaimer;

    @JsonSerialize(using = ProductDisclosuresSerializer.class)
    private List<ProductDisclosure> productDisclosures;

    private String inclusions;

    private String benefits;

    private String optionalExtras;

    private String vdn;

    private String followupIntended;

    private String leadfeedinfo;

    public CarResult() {
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

    public Excess getExcesses() {
        return this.excesses;
    }

    public void setExcesses(Excess excesses) {
        this.excesses = excesses;
    }

    public String getExcess() {
        return this.excesses.getBasicExcess();
    }

    public void setExcess(String excess) {
        if(this.excesses == null) {
            this.excesses = new Excess();
        }

        this.excesses.setBasicExcess(excess);
    }

    public String getGlassExcess() { return this.excesses.getGlassExcess(); }

    public void setGlassExcess(String glassExcess) {
        if(this.excesses == null) {
            this.excesses = new Excess();
        }

        this.excesses.setGlassExcess(glassExcess);
    }

    public List<AdditionalExcess> getAdditionalExcesses() {
        return this.additionalExcesses;
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

    public String getLeadfeedinfo() {
        return leadfeedinfo;
    }

    public void setLeadfeedinfo(String leadfeedinfo) {
        this.leadfeedinfo = leadfeedinfo;
    }
}
