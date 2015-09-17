package com.ctm.providers.health.healthapply.model.request;

import com.ctm.providers.health.healthapply.model.request.application.ApplicationGroup;
import com.ctm.providers.health.healthapply.model.request.contactDetails.ContactDetails;
import com.ctm.providers.health.healthapply.model.request.fundData.FundData;
import com.ctm.providers.health.healthapply.model.request.payment.Payment;
import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

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

    @Size(min = 1, max = 1)
    public final List<String> providerFilter;

    public HealthApplicationRequest(final ContactDetails contactDetails, final Payment payment, final FundData fundData,
                                    final ApplicationGroup applicants, final List<String> providerFilter) {
        this.contactDetails = contactDetails;
        this.payment = payment;
        this.fundData = fundData;
        this.applicants = applicants;
        this.providerFilter = providerFilter;
    }
}
