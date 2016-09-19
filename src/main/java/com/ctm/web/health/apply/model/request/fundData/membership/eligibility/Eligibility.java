
package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Eligibility {

    private EligibilityReasonID eligibilityReasonID;

    private EligibilitySubReasonID eligibilitySubReasonID;

    private NhbEligibilityReasonID nhbEligibilityReasonID;

    private NhbEligibilitySubReasonID nhbEligibilitySubReasonID;

    private Eligibility(Builder builder) {
        eligibilityReasonID = builder.eligibilityReasonID;
        eligibilitySubReasonID = builder.eligibilitySubReasonID;
        nhbEligibilityReasonID = builder.nhbEligibilityReasonID;
        nhbEligibilitySubReasonID = builder.nhbEligibilitySubReasonID;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    @JsonProperty("eligibilityReasonID")
    @JsonSerialize(using = TypeSerializer.class)
    public EligibilityReasonID getEligibilityReasonID() {
        return eligibilityReasonID;
    }

    @JsonProperty("eligibilitySubReasonID")
    @JsonSerialize(using = TypeSerializer.class)
    public EligibilitySubReasonID getEligibilitySubReasonID() {
        return eligibilitySubReasonID;
    }

    @JsonProperty("EligibilityReasonID")
    public NhbEligibilityReasonID getNhbEligibilityReasonID() {
        return nhbEligibilityReasonID;
    }

    @JsonProperty("EligibilitySubReasonID")
    public NhbEligibilitySubReasonID getNhbEligibilitySubReasonID() {
        return nhbEligibilitySubReasonID;
    }


    public static final class Builder {
        private EligibilityReasonID eligibilityReasonID;
        private EligibilitySubReasonID eligibilitySubReasonID;
        private NhbEligibilityReasonID nhbEligibilityReasonID;
        private NhbEligibilitySubReasonID nhbEligibilitySubReasonID;

        private Builder() {
        }

        public Builder eligibilityReasonID(EligibilityReasonID val) {
            eligibilityReasonID = val;
            return this;
        }

        public Builder eligibilitySubReasonID(EligibilitySubReasonID val) {
            eligibilitySubReasonID = val;
            return this;
        }

        public Builder nhbEligibilityReasonID(NhbEligibilityReasonID val) {
            nhbEligibilityReasonID = val;
            return this;
        }

        public Builder nhbEligibilitySubReasonID(NhbEligibilitySubReasonID val) {
            nhbEligibilitySubReasonID = val;
            return this;
        }

        public Eligibility build() {
            return new Eligibility(this);
        }
    }
}
