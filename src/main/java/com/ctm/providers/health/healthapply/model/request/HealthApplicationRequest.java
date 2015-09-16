package com.ctm.providers.health.healthapply.model.request;

import com.ctm.healthapply.model.request.application.ApplicationGroup;
import com.ctm.healthapply.model.request.contactDetails.ContactDetails;
import com.ctm.healthapply.model.request.fundData.FundData;
import com.ctm.healthapply.model.request.payment.Payment;
import com.ctm.interfaces.common.aggregator.request.QuoteRequest;
import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;
import java.util.Optional;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class HealthApplicationRequest implements QuoteRequest {

    @NotNull
    private ContactDetails contactDetails;

    @NotNull
    private Payment payment;

    @NotNull
    private FundData fundData;

    @NotNull
    private ApplicationGroup applicants;

    @Size(min = 1, max = 1)
    public List<String> providerFilter;

    public Optional<ContactDetails> getContactDetails() {
        return Optional.ofNullable(contactDetails);
    }

    public Optional<Payment> getPayment() {
        return Optional.ofNullable(payment);
    }

    public Optional<FundData> getFundData() {
        return Optional.ofNullable(fundData);
    }

    public Optional<ApplicationGroup> getApplicants() {
        return Optional.ofNullable(applicants);
    }

    public List<String> getProviderFilter() {
        return providerFilter;
    }


}
