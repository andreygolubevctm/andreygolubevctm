package com.ctm.web.health.apply.model.request;

import com.ctm.healthcommon.abd.CombinedAbdSummary;
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
    private String cid;
    private String trialCampaign;

    private CombinedAbdSummary abdSummary;


    private HealthApplicationRequest(Builder builder) {
        contactDetails = builder.contactDetails;
        payment = builder.payment;
        fundData = builder.fundData;
        applicants = builder.applicants;
        providerFilter = builder.providerFilter;
        operator = builder.operator;
        cid = builder.cid;
        trialCampaign = builder.trialCampaign;
        abdSummary = builder.abdSummary;
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

    public String getCid() {
        return cid;
    }

    public String getTrialCampaign() {
        return trialCampaign;
    }

    public CombinedAbdSummary getAbdSummary() {
        return abdSummary;
    }

    public static final class Builder {
        private ContactDetails contactDetails;
        private Payment payment;
        private FundData fundData;
        private ApplicationGroup applicants;
        private List<String> providerFilter;
        private String operator;
        private String cid;
        private String trialCampaign;
        private CombinedAbdSummary abdSummary;

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

        public Builder cid(String val) {
            cid = val;
            return this;
        }

        public Builder trialCampaign(String val) {
            trialCampaign = val;
            return this;
        }

        public Builder abdSummary(CombinedAbdSummary val) {
            this.abdSummary = val;
            return this;
        }

        public HealthApplicationRequest build() {
            return new HealthApplicationRequest(this);
        }
    }
}
