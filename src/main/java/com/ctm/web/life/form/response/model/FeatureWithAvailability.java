package com.ctm.web.life.form.response.model;


import java.util.Optional;

public class FeatureWithAvailability {
    private String id;
    private String name;
    private Optional<Integer> available;

    private FeatureWithAvailability() {
    }

    private FeatureWithAvailability(FeatureWithAvailability.Builder builder) {
        this.id = builder.id;
        this.name = builder.name;
        this.available = builder.available;
    }

    public String getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public Optional<Integer> getAvailable() {
        return this.available;
    }

    public static final class Builder {
        private String id;
        private String name;
        private Optional<Integer> available;

        public Builder() {
        }

        public FeatureWithAvailability.Builder id(String val) {
            this.id = val;
            return this;
        }

        public FeatureWithAvailability.Builder name(String val) {
            this.name = val;
            return this;
        }

        public FeatureWithAvailability.Builder available(Optional<Integer> val) {
            this.available = val;
            return this;
        }

        public FeatureWithAvailability build() {
            return new FeatureWithAvailability(this);
        }
    }
}
