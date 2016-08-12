package com.ctm.web.health.apply.v2.model.request;

import com.ctm.web.health.apply.v2.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.v2.model.request.contactDetails.ContactDetails;
import com.ctm.web.health.apply.v2.model.request.fundData.FundData;
import com.ctm.web.health.apply.v2.model.request.payment.Payment;
import com.fasterxml.jackson.annotation.JsonInclude;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class HealthApplicationRequest {

    private ContactDetails contactDetails;

    @NotNull
    private Payment payment;

    @NotNull
    private FundData fundData;

    @NotNull
    private ApplicationGroup applicants;

    @Deprecated
    @Size(min = 1, max = 1)
    public List<String> providerFilter;

    private String operator;

    private HealthApplicationRequest(Builder builder) {
        contactDetails = builder.contactDetails;
        payment = builder.payment;
        fundData = builder.fundData;
        applicants = builder.applicants;
        providerFilter = builder.providerFilter;
        operator = builder.operator;
    }

    public static Builder newBuilder() {
        return new Builder();
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

    public String getOperator() {
        return operator;
    }

    public static final class Builder {
        private ContactDetails contactDetails;
        private Payment payment;
        private FundData fundData;
        private ApplicationGroup applicants;
        private List<String> providerFilter;
        private String operator;

        private Builder() {
        }

        public Builder contactDetails(ContactDetails val) {
            contactDetails = val;
            return this;
        }

        public Builder payment(Payment val) {
            payment = val;
            return this;
        }

        public Builder fundData(FundData val) {
            fundData = val;
            return this;
        }

        public Builder applicants(ApplicationGroup val) {
            applicants = val;
            return this;
        }

        public Builder providerFilter(List<String> val) {
            providerFilter = val;
            return this;
        }

        public Builder operator(String val) {
            operator = val;
            return this;
        }

        public HealthApplicationRequest build() {
            return new HealthApplicationRequest(this);
        }
    }
}
