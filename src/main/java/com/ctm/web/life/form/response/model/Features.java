package com.ctm.web.life.form.response.model;

import com.fasterxml.jackson.annotation.JsonProperty;


public class Features {

    private FeaturesInner features;
    @JsonProperty("special_offers")
    private FeaturesInner specialOffers;
    @JsonProperty("whats_included")
    private  FeaturesInner whatsIncluded;
    @JsonProperty("optional_extras")
    private  FeaturesInner optionalExtras;
    private  FeaturesInner exclusions;

    public FeaturesInner getFeatures() {
        return features;
    }

    public void setFeatures(FeaturesInner features) {
        this.features = features;
    }

    public FeaturesInner getSpecialOffers() {
        return specialOffers;
    }

    public void setSpecialOffers(FeaturesInner specialOffers) {
        this.specialOffers = specialOffers;
    }

    public FeaturesInner getWhatsIncluded() {
        return whatsIncluded;
    }

    public void setWhatsIncluded(FeaturesInner whatsIncluded) {
        this.whatsIncluded = whatsIncluded;
    }

    public FeaturesInner getOptionalExtras() {
        return optionalExtras;
    }

    public void setOptionalExtras(FeaturesInner optionalExtras) {
        this.optionalExtras = optionalExtras;
    }

    public FeaturesInner getExclusions() {
        return exclusions;
    }

    public void setExclusions(FeaturesInner exclusions) {
        this.exclusions = exclusions;
    }
}
