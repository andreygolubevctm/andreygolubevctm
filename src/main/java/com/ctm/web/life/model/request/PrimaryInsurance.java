package com.ctm.web.life.model.request;

import com.ctm.web.core.model.formData.YesNo;

public class PrimaryInsurance extends Insurance {

    private YesNo samecover;

    public PrimaryInsurance(Builder builder) {
        super(builder);
        samecover = builder.samecover;
    }
    public PrimaryInsurance() {
        super();
    }

    public YesNo getSamecover() {
        return samecover;
    }


    public static final class Builder extends Insurance.Builder {
        private YesNo samecover;

        public Builder() {
        }

        public Builder samecover(YesNo val) {
            samecover = val;
            return this;
        }

        @Override
        public PrimaryInsurance build() {
            return new PrimaryInsurance(this);
        }
    }
}
