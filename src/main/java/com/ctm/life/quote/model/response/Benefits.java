package com.ctm.life.quote.model.response;


import java.util.List;

public class Benefits {

    private List<Feature> features;
    private List<Feature> specialOffers;
    private List<Feature> whatsIncluded;
    private List<Feature> optionalExtras;
    private List<Feature>  exclusions;

    // used by jackson
    @SuppressWarnings("unused")
    private Benefits() {
    }

    private Benefits(Builder builder) {
        features = builder.features;
        specialOffers = builder.specialOffers;
        whatsIncluded = builder.whatsIncluded;
        optionalExtras = builder.optionalExtras;
        exclusions = builder.exclusions;
    }

    public List<Feature> getFeatures() {
        return features;
    }

    public List<Feature> getSpecialOffers() {
        return specialOffers;
    }

    public List<Feature> getWhatsIncluded() {
        return whatsIncluded;
    }

    public List<Feature> getOptionalExtras() {
        return optionalExtras;
    }

    public List<Feature> getExclusions() {
        return exclusions;
    }


    public static final class Builder {
        private List<Feature> features;
        private List<Feature> specialOffers;
        private List<Feature> whatsIncluded;
        private List<Feature> optionalExtras;
        private List<Feature> exclusions;

        public Builder features(List<Feature> val) {
            features = val;
            return this;
        }

        public Builder specialOffers(List<Feature> val) {
            specialOffers = val;
            return this;
        }

        public Builder whatsIncluded(List<Feature> val) {
            whatsIncluded = val;
            return this;
        }

        public Builder optionalExtras(List<Feature> val) {
            optionalExtras = val;
            return this;
        }

        public Builder exclusions(List<Feature> val) {
            exclusions = val;
            return this;
        }

        public Benefits build() {
            return new Benefits(this);
        }
    }
}
