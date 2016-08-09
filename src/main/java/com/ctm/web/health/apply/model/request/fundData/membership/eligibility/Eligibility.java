
package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.ctm.web.health.apply.helper.TypeSerializer;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

public class Eligibility {

    @JsonSerialize(using = TypeSerializer.class)
    private EligibilityReasonID eligibilityReasonID;

    @JsonSerialize(using = TypeSerializer.class)
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
