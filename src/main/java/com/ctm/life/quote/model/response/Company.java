package com.ctm.life.quote.model.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Company {

    @NotNull
    private String name;

    private String info;
    private String insurerContact;

    @SuppressWarnings("unused")
    private Company() {
    }

    private Company(Builder builder) {
        name = builder.name;
        insurerContact = builder.insurerContact;
        info = builder.info;
    }

    public String getName() {
        return name;
    }

    public String getInsurerContact() {
        return insurerContact;
    }


    public Optional<String> getInfo() {
        return Optional.ofNullable(info);
    }


    public static final class Builder {
        private String name;
        private String insurerContact;
        private String info;

        public Builder info(Optional<String> val) {
            info = val.orElse(null);
            return this;
        }

        public Builder name(String val) {
            name = val;
            return this;
        }

        public Builder insurerContact(String val) {
            insurerContact = val;
            return this;
        }

        public Company build() {
            return new Company(this);
        }
    }
}
