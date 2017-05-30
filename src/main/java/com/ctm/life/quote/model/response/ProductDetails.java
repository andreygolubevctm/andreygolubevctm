package com.ctm.life.quote.model.response;

public class ProductDetails {

    private String specialOffer;
    private String leadNumber;
    private String fsg;
    private String callCentreHours;
    private Benefits benefits;

    // used by jackson
    @SuppressWarnings("unused")
    private ProductDetails() {
    }

    private ProductDetails(Builder builder) {
        specialOffer = builder.specialOffer;
        leadNumber = builder.leadNumber;
        fsg = builder.fsg;
        callCentreHours = builder.callCentreHours;
        benefits = builder.benefits;
    }

    public String getSpecialOffer() {
        return specialOffer;
    }

    public String getLeadNumber() {
        return leadNumber;
    }

    public String getFsg() {
        return fsg;
    }

    public String getCallCentreHours() {
        return callCentreHours;
    }

    public Benefits getBenefits() {
        return benefits;
    }


    public static final class Builder {
        private String specialOffer;
        private String leadNumber;
        private String fsg;
        private String callCentreHours;
        private Benefits benefits;

        public Builder specialOffer(String val) {
            specialOffer = val;
            return this;
        }

        public Builder leadNumber(String val) {
            leadNumber = val;
            return this;
        }

        public Builder fsg(String val) {
            fsg = val;
            return this;
        }

        public Builder callCentreHours(String val) {
            callCentreHours = val;
            return this;
        }

        public Builder benefits(Benefits val) {
            benefits = val;
            return this;
        }

        public ProductDetails build() {
            return new ProductDetails(this);
        }
    }
}
