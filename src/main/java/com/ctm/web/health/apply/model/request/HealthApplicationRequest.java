package com.ctm.web.health.apply.model.request;

import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.contactDetails.ContactDetails;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.payment.Payment;
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

    @Deprecated
    @Size(min = 1, max = 1)
    public List<String> providerFilter;

    private HealthApplicationRequest(final ContactDetails contactDetails, final Payment payment, final FundData fundData,
                                    final ApplicationGroup applicants, final List<String> providerFilter) {
        this.contactDetails = contactDetails;
        this.payment = payment;
        this.fundData = fundData;
        this.applicants = applicants;
        this.providerFilter = providerFilter;
    }

    public static final HealthApplicationRequest instanceOf(final ContactDetails contactDetails, final Payment payment, final FundData fundData,
                                                              final ApplicationGroup applicants, final List<String> providerFilter) {
        return new HealthApplicationRequest(contactDetails, payment, fundData, applicants, providerFilter);
    }

    public static final HealthApplicationRequest instanceOfV2(final ContactDetails contactDetails, final Payment payment, final FundData fundData,
                                                              final ApplicationGroup applicants) {
        return new HealthApplicationRequest(contactDetails, payment, fundData, applicants, null);
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

    @Deprecated
    public List<String> getProviderFilter() {
        return providerFilter;
    }
}
