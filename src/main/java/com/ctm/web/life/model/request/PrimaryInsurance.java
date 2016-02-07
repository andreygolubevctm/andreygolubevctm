package com.ctm.web.life.model.request;

import com.ctm.web.core.model.formData.YesNo;

public class PrimaryInsurance extends Insurance {

    private YesNo samecover;
    private YesNo partner;

    public PrimaryInsurance(Builder builder) {
        super(builder);
        samecover = builder.samecover;
        partner = builder.partner;
    }
    public PrimaryInsurance() {
        super();
    }

    public YesNo getSamecover() {
        return samecover;
    }

    public YesNo getPartner() {
        return partner;
    }


    public static final class Builder extends Insurance.Builder {
        private YesNo samecover;
        private YesNo partner;

        public Builder() {
        }

        public Builder samecover(YesNo val) {
            samecover = val;
            return this;
        }

        public Builder partner(YesNo val) {
            partner = val;
            return this;
        }

        @Override
        public PrimaryInsurance build() {
            return new PrimaryInsurance(this);
        }
    }
}
