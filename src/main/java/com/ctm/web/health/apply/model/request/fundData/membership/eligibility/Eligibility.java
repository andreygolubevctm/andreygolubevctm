
package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Eligibility {

    @JsonProperty("EligibilityReasonID")
    private EligibilityReasonID eligibilityReasonID;

    @JsonProperty("EligibilitySubReasonID")
    private EligibilitySubReasonID eligibilitySubReasonID;

    public Eligibility(final EligibilityReasonID eligibilityReasonID,
                        final EligibilitySubReasonID eligibilitySubReasonID) {
        this.eligibilityReasonID = eligibilityReasonID;
        this.eligibilitySubReasonID = eligibilitySubReasonID;
    }

    public EligibilityReasonID getEligibilityReasonID() {
        return eligibilityReasonID;
    }

    public EligibilitySubReasonID getEligibilitySubReasonID() {
        return eligibilitySubReasonID;
    }
}
