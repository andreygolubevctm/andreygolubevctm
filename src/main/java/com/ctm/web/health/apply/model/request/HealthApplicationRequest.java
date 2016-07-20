package com.ctm.web.health.apply.model.request;

import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.contactDetails.ContactDetails;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.payment.Payment;
import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class HealthApplicationRequest {

    private final ContactDetails contactDetails;

    @NotNull
    private final Payment payment;

    @NotNull
    private final FundData fundData;

    @NotNull
    private final ApplicationGroup applicants;

    public HealthApplicationRequest(final ContactDetails contactDetails, final Payment payment, final FundData fundData,
                                    final ApplicationGroup applicants) {
        this.contactDetails = contactDetails;
        this.payment = payment;
        this.fundData = fundData;
        this.applicants = applicants;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }

    public Payment getPayment() {
        return payment;
    }

    public FundData getFundData() {
        return fundData;
    }

    public ApplicationGroup getApplicants() {
        return applicants;
    }
}
