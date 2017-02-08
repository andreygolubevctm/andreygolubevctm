package com.ctm.web.simples.model;

public class RemainingSale {

    private String fundName;

    private int remainingSales;

    private int remainingDays;

    private RemainingSale(final Builder builder) {
        fundName = builder.fundName;
        remainingSales = builder.remainingSales;
        remainingDays = builder.remainingDays;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getFundName() {
        return fundName;
    }

    public int getRemainingSales() {
        return remainingSales;
    }

    public int getRemainingDays() {
        return remainingDays;
    }

    public static final class Builder {
        private String fundName;
        private int remainingSales;
        private int remainingDays;

        private Builder() {
        }

        public Builder fundName(final String val) {
            fundName = val;
            return this;
        }

        public Builder remainingSales(final int val) {
            remainingSales = val;
            return this;
        }

        public Builder remainingDays(final int val) {
            remainingDays = val;
            return this;
        }

        public RemainingSale build() {
            return new RemainingSale(this);
        }
    }
}
