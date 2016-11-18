package com.ctm.web.health.email.model;

import com.ctm.web.core.email.model.BestPriceRanking;

import java.util.Optional;

public class HealthBestPriceRanking extends BestPriceRanking {

    private String hospitalPdsUrl;

    private String extrasPdsUrl;

    private String specialOffer;

    private String specialOfferTerms;

    private String premiumTotal;

    private String excessPerAdmission;

    private String excessPerPerson;

    private String excessPerPolicy;

    private String coPayment;

    private String loadQuoteUrl;

    public Optional<String> getHospitalPdsUrl() {
        return Optional.ofNullable(hospitalPdsUrl);
    }

    public void setHospitalPdsUrl(String hospitalPdsUrl) {
        this.hospitalPdsUrl = hospitalPdsUrl;
    }

    public Optional<String> getExtrasPdsUrl() {
        return Optional.ofNullable(extrasPdsUrl);
    }

    public void setExtrasPdsUrl(String extrasPdsUrl) {
        this.extrasPdsUrl = extrasPdsUrl;
    }

    public Optional<String> getSpecialOffer() {
        return Optional.ofNullable(specialOffer);
    }

    public void setSpecialOffer(String specialOffer) {
        this.specialOffer = specialOffer;
    }

    public Optional<String> getSpecialOfferTerms() {
        return Optional.ofNullable(specialOfferTerms);
    }

    public void setSpecialOfferTerms(String specialOfferTerms) {
        this.specialOfferTerms = specialOfferTerms;
    }

    public Optional<String> getPremiumTotal() {
        return Optional.ofNullable(premiumTotal);
    }

    public void setPremiumTotal(String premiumTotal) {
        this.premiumTotal = premiumTotal;
    }

    public Optional<String> getExcessPerAdmission() {
        return Optional.ofNullable(excessPerAdmission);
    }

    public void setExcessPerAdmission(String excessPerAdmission) {
        this.excessPerAdmission = excessPerAdmission;
    }

    public Optional<String> getExcessPerPerson() {
        return Optional.ofNullable(excessPerPerson);
    }

    public void setExcessPerPerson(String excessPerPerson) {
        this.excessPerPerson = excessPerPerson;
    }

    public Optional<String> getExcessPerPolicy() {
        return Optional.ofNullable(excessPerPolicy);
    }

    public void setExcessPerPolicy(String excessPerPolicy) {
        this.excessPerPolicy = excessPerPolicy;
    }

    public Optional<String> getCoPayment() {
        return Optional.ofNullable(coPayment);
    }

    public void setCoPayment(String coPayment) {
        this.coPayment = coPayment;
    }

    public Optional<String> getLoadQuoteUrl() {
        return Optional.ofNullable(loadQuoteUrl);
    }

    public void setLoadQuoteUrl(String loadQuoteUrl) {
        this.loadQuoteUrl = loadQuoteUrl;
    }
}
