
package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

public class Eligibility {

    private EligibilityReasonID eligibilityReasonID;

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
