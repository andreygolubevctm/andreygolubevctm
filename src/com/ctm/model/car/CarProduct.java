package com.ctm.model.car;

import com.ctm.model.Feature;
import com.fasterxml.jackson.annotation.JsonView;

import java.util.ArrayList;
import java.util.List;

public class CarProduct {

    private String code;

    private String providerProductName;

    private String brandCode;

    private String quoteUrl;

    private String disclaimer;

    private String name;

    private String description;

    private String discountOffer;

    private String discountOfferTerms;

    private String underwriterName;

    private String underwriterABN;

    private String underwriterACN;

    private String underwriterAFSLicenceNo;

    private Boolean allowCallMeBack;

    private Boolean allowCallDirect;

    private String callCentreHours;

    private String phoneNumber;

    private String offlineDiscount;

    private String onlineDiscount;

    private List<AdditionalExcess> additionalExcesses = new ArrayList<>();

    private String specialConditions;

    private List<Feature> features = new ArrayList<>();

    private List<ProductDisclosure> productDisclosures = new ArrayList<>();

    @JsonView(Views.MoreInfoView.class) private String inclusions;

    @JsonView(Views.MoreInfoView.class) private String benefits;

    @JsonView(Views.MoreInfoView.class) private String optionalExtras;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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

    public String getQuoteUrl() {
        return quoteUrl;
    }

    public void setQuoteUrl(String quoteUrl) {
        this.quoteUrl = quoteUrl;
    }

    public String getDisclaimer() {
        return disclaimer;
    }

    public void setDisclaimer(String disclaimer) {
        this.disclaimer = disclaimer;
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

    public String getUnderwriterName() {
        return underwriterName;
    }

    public void setUnderwriterName(String underwriterName) {
        this.underwriterName = underwriterName;
    }

    public String getUnderwriterABN() {
        return underwriterABN;
    }

    public void setUnderwriterABN(String underwriterABN) {
        this.underwriterABN = underwriterABN;
    }

    public String getUnderwriterACN() {
        return underwriterACN;
    }

    public void setUnderwriterACN(String underwriterACN) {
        this.underwriterACN = underwriterACN;
    }

    public String getUnderwriterAFSLicenceNo() {
        return underwriterAFSLicenceNo;
    }

    public void setUnderwriterAFSLicenceNo(String underwriterAFSLicenceNo) {
        this.underwriterAFSLicenceNo = underwriterAFSLicenceNo;
    }

    public Boolean isAllowCallMeBack() {
        return allowCallMeBack;
    }

    public void setAllowCallMeBack(Boolean allowCallMeBack) {
        this.allowCallMeBack = allowCallMeBack;
    }

    public Boolean isAllowCallDirect() {
        return allowCallDirect;
    }

    public void setAllowCallDirect(boolean allowCallDirect) {
        this.allowCallDirect = allowCallDirect;
    }

    public String getCallCentreHours() {
        return callCentreHours;
    }

    public void setCallCentreHours(String callCentreHours) {
        this.callCentreHours = callCentreHours;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getOfflineDiscount() {
        return offlineDiscount;
    }

    public void setOfflineDiscount(String offlineDiscount) {
        this.offlineDiscount = offlineDiscount;
    }

    public String getOnlineDiscount() {
        return onlineDiscount;
    }

    public void setOnlineDiscount(String onlineDiscount) {
        this.onlineDiscount = onlineDiscount;
    }

    public List<AdditionalExcess> getAdditionalExcesses() {
        return additionalExcesses;
    }

    public String getSpecialConditions() {
        return specialConditions;
    }

    public void setSpecialConditions(String specialConditions) {
        this.specialConditions = specialConditions;
    }

    public List<Feature> getFeatures() {
        return features;
    }

    public List<ProductDisclosure> getProductDisclosures() {
        return productDisclosures;
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
}
