package com.ctm.web.life.form.response.model;

import com.ctm.life.quote.model.response.Feature;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class Features {

    private List<Feature> feature;
    @JsonProperty("special_offers")
    private List<Feature> specialOffers;
    @JsonProperty("whats_included")
    private  List<Feature> whatsIncluded;
    @JsonProperty("optional_extras")
    private  List<Feature> optionalExtras;
    private  List<Feature> exclusions;

    public List<Feature> getFeature() {
        return feature;
    }

    public void setFeature(List<Feature> features) {
        this.feature = features;
    }

    public List<Feature> getSpecialOffers() {
        return specialOffers;
    }

    public void setSpecialOffers(List<Feature> specialOffers) {
        this.specialOffers = specialOffers;
    }

    public List<Feature> getWhatsIncluded() {
        return whatsIncluded;
    }

    public void setWhatsIncluded(List<Feature> whatsIncluded) {
        this.whatsIncluded = whatsIncluded;
    }

    public List<Feature> getOptionalExtras() {
        return optionalExtras;
    }

    public void setOptionalExtras(List<Feature> optionalExtras) {
        this.optionalExtras = optionalExtras;
    }

    public List<Feature> getExclusions() {
        return exclusions;
    }

    public void setExclusions(List<Feature> exclusions) {
        this.exclusions = exclusions;
    }
}
