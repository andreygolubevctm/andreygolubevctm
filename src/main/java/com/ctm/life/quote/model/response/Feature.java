package com.ctm.life.quote.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Feature {
    private String id;
    private String name;

    private Boolean available;

    // used by jackson
    @SuppressWarnings("unused")
    private Feature() {
    }

    private Feature(Builder builder) {
        id = builder.id;
        name = builder.name;
        available = builder.available;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Optional<Boolean> getAvailable() {
        return Optional.ofNullable(available);
    }


    public static final class Builder {
        private String id;
        private String name;
        private Boolean available;


        public Builder id(String val) {
            id = val;
            return this;
        }

        public Builder name(String val) {
            name = val;
            return this;
        }

        public Builder available(Optional<Boolean> val) {
            available = val.orElse(null);
            return this;
        }

        public Feature build() {
            return new Feature(this);
        }
    }
}
