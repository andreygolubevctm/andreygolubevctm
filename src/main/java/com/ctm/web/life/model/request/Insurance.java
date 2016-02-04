package com.ctm.web.life.model.request;

import java.math.BigDecimal;

public class Insurance {

    private BigDecimal term;
    private String termentry;
    private BigDecimal tpd;
    private String tpdentry;
    private BigDecimal trauma;
    private String traumaentry;
    private String tpdanyown;
    private String frequency;
    private String type;

    protected Insurance(Builder builder) {
        term = builder.term;
        termentry = builder.termentry;
        tpd = builder.tpd;
        tpdentry = builder.tpdentry;
        trauma = builder.trauma;
        traumaentry = builder.traumaentry;
        tpdanyown = builder.tpdanyown;
        frequency = builder.frequency;
        type = builder.type;
    }

    protected Insurance() {
    }

    public BigDecimal getTerm() {
        return term;
    }

    public String getTermentry() {
        return termentry;
    }

    public BigDecimal getTpd() {
        return tpd;
    }

    public String getTpdentry() {
        return tpdentry;
    }

    public BigDecimal getTrauma() {
        return trauma;
    }

    public String getTraumaentry() {
        return traumaentry;
    }

    public String getTpdanyown() {
        return tpdanyown;
    }

    public String getFrequency() {
        return frequency;
    }

    public String getType() {
        return type;
    }


    public static class Builder {
        private BigDecimal term;
        private String termentry;
        private BigDecimal tpd;
        private String tpdentry;
        private BigDecimal trauma;
        private String traumaentry;
        private String tpdanyown;
        private String frequency;
        private String type;

        public Builder() {
        }

        public Builder term(BigDecimal val) {
            term = val;
            return this;
        }

        public Builder termentry(String val) {
            termentry = val;
            return this;
        }

        public Builder tpd(BigDecimal val) {
            tpd = val;
            return this;
        }

        public Builder tpdentry(String val) {
            tpdentry = val;
            return this;
        }

        public Builder trauma(BigDecimal val) {
            trauma = val;
            return this;
        }

        public Builder traumaentry(String val) {
            traumaentry = val;
            return this;
        }

        public Builder tpdanyown(String val) {
            tpdanyown = val;
            return this;
        }

        public Builder frequency(String val) {
            frequency = val;
            return this;
        }

        public Builder type(String val) {
            type = val;
            return this;
        }

        public Insurance build() {
            return new Insurance(this);
        }
    }
}
