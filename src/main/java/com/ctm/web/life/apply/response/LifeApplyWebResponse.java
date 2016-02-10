package com.ctm.web.life.apply.response;

public class LifeApplyWebResponse {

    LifeApplyWebResponseResults results;

    private LifeApplyWebResponse(Builder builder) {
        results = builder.results;
    }

    public LifeApplyWebResponseResults getResults() {
        return results;
    }


    public static final class Builder {
        private LifeApplyWebResponseResults results;

        public Builder() {
        }

        public Builder results(LifeApplyWebResponseResults val) {
            results = val;
            return this;
        }

        public LifeApplyWebResponse build() {
            return new LifeApplyWebResponse(this);
        }
    }
}
