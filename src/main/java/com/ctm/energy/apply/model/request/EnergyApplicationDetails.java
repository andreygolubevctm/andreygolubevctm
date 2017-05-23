package com.ctm.energy.apply.model.request;

import com.ctm.energy.apply.model.request.application.address.ApplicationAddress;
import com.ctm.energy.apply.model.request.application.applicant.ApplicantDetails;
import com.ctm.energy.apply.model.request.application.contact.ContactDetails;
import com.ctm.energy.apply.model.request.relocation.RelocationDetails;

import javax.validation.constraints.NotNull;

public class EnergyApplicationDetails {

    private String partnerUniqueCustomerId;

    @NotNull
    private ApplicantDetails applicantDetails;

    @NotNull
    private ContactDetails contactDetails;

    private RelocationDetails relocationDetails;

    private ApplicationAddress address;

    private EnergyApplicationDetails() {
    }

    private EnergyApplicationDetails(Builder builder) {
        partnerUniqueCustomerId = builder.partnerUniqueCustomerId;
        applicantDetails = builder.applicantDetails;
        contactDetails = builder.contactDetails;
        relocationDetails = builder.relocationDetails;
        address = builder.address;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public String getPartnerUniqueCustomerId() {
        return partnerUniqueCustomerId;
    }

    public ApplicantDetails getApplicantDetails() {
        return applicantDetails;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }

    public RelocationDetails getRelocationDetails() {
        return relocationDetails;
    }

    public ApplicationAddress getAddress() {
        return address;
    }


    public static final class Builder {
        private String partnerUniqueCustomerId;
        private ApplicantDetails applicantDetails;
        private ContactDetails contactDetails;
        private RelocationDetails relocationDetails;
        private ApplicationAddress address;

        private Builder() {
        }

        public Builder partnerUniqueCustomerId(String val) {
            partnerUniqueCustomerId = val;
            return this;
        }

        public Builder applicantDetails(ApplicantDetails val) {
            applicantDetails = val;
            return this;
        }

        public Builder contactDetails(ContactDetails val) {
            contactDetails = val;
            return this;
        }

        public Builder relocationDetails(RelocationDetails val) {
            relocationDetails = val;
            return this;
        }

        public Builder address(ApplicationAddress val) {
            address = val;
            return this;
        }

        public EnergyApplicationDetails build() {
            return new EnergyApplicationDetails(this);
        }
    }
}
