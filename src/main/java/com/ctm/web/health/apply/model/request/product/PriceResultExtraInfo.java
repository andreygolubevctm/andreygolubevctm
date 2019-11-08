package com.ctm.web.health.apply.model.request.product;

import java.util.Optional;

public class PriceResultExtraInfo {

    private PricePremiums pricePremiums;
    private String fundCode;
    private String fundName;
    private String restrictedFund;
    private String phioData;
    private String extrasName;
    private String hospitalName;
    private String fundProductCode;
    private Integer excess;
    private String title;
    private String productId;
    private String productType;
    private String abdFlag;

    private PriceResultExtraInfo(final Builder builder) {
        pricePremiums = builder.pricePremiums;
        fundCode = builder.fundCode;
        fundName = builder.fundName;
        restrictedFund = builder.restrictedFund;
        phioData = builder.phioData;
        extrasName = builder.extrasName;
        hospitalName = builder.hospitalName;
        fundProductCode = builder.fundProductCode;
        excess = builder.excess;
        title = builder.title;
        productId = builder.productId;
        productType = builder.productType;
        abdFlag = builder.abdFlag;
    }



    public static Builder newBuilder() {
        return new Builder();
    }

    public static Builder newBuilder(final PriceResultExtraInfo copy) {
        final Builder builder = new Builder();
        builder.pricePremiums = copy.pricePremiums;
        builder.fundCode = copy.fundCode;
        builder.fundName = copy.fundName;
        builder.restrictedFund = copy.restrictedFund;
        builder.phioData = copy.phioData;
        builder.extrasName = copy.extrasName;
        builder.hospitalName = copy.hospitalName;
        builder.fundProductCode = copy.fundProductCode;
        builder.excess = copy.excess;
        builder.title = copy.title;
        builder.productType = copy.productType;
        builder.abdFlag = copy.abdFlag;
        return builder;
    }

    public PricePremiums getPricePremiums() {
        return pricePremiums;
    }

    public Optional<String> getFundCode() {
        return Optional.ofNullable(fundCode);
    }

    public Optional<String> getFundName() {
        return Optional.ofNullable(fundName);
    }

    public Optional<String> getPhioData() {
        return Optional.ofNullable(phioData);
    }

    public Optional<String> getExtrasName() {
        return Optional.ofNullable(extrasName);
    }

    public Optional<String> getHospitalName() {
        return Optional.ofNullable(hospitalName);
    }

    public Optional<String> getFundProductCode() {
        return Optional.ofNullable(fundProductCode);
    }

    public Optional<Integer> getExcess() {
        return Optional.ofNullable(excess);
    }

    public Optional<String> getTitle() {
        return Optional.ofNullable(title);
    }

    public Optional<String> getRestrictedFund() {
        return Optional.ofNullable(restrictedFund);
    }

    public String getProductId() {
        return productId;
    }

	public Optional<String> getProductType() {
		return Optional.ofNullable(productType);
	}

    public String getAbdFlag() {
        return Optional.ofNullable(abdFlag).orElse("N");
    }

    public static final class Builder {
        private PricePremiums pricePremiums;
        private String fundCode;
        private String fundName;
        private String restrictedFund;
        private String phioData;
        private String extrasName;
        private String hospitalName;
        private String fundProductCode;
        private Integer excess;
        private String title;
        private String productId;
        private String productType;
        private String abdFlag;

        private Builder() {
        }

        public Builder pricePremiums(final PricePremiums val) {
            pricePremiums = val;
            return this;
        }

        public Builder fundCode(final String val) {
            fundCode = val;
            return this;
        }

        public Builder fundName(final String val) {
            fundName = val;
            return this;
        }

        public Builder restrictedFund(final String val) {
            restrictedFund = val;
            return this;
        }

        public Builder phioData(final String val) {
            phioData = val;
            return this;
        }

        public Builder extrasName(final String val) {
            extrasName = val;
            return this;
        }

        public Builder hospitalName(final String val) {
            hospitalName = val;
            return this;
        }

        public Builder fundProductCode(final String val) {
            fundProductCode = val;
            return this;
        }

        public Builder excess(final Integer val) {
            excess = val;
            return this;
        }

        public Builder title(final String val) {
            title = val;
            return this;
        }

        public Builder productId(final String val) {
            productId = val;
            return this;
        }

        public Builder productType(final String val) {
            productType = val;
            return this;
        }

        public PriceResultExtraInfo build() {
            return new PriceResultExtraInfo(this);
        }

        public Builder abdFlag(String s) {
            abdFlag = s;
            return this;
        }
    }
}
