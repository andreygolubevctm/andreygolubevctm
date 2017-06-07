package com.ctm.life.apply.model.request.lifebroker;

import com.ctm.life.model.request.Applicants;
import com.ctm.life.model.request.ContactDetails;

import java.util.Optional;

public class LifeBrokerApplyRequest  {

    public static final String PATH = "/lifebroker";

    private Applicants applicants;

    private ContactDetails contactDetails;

    private String partnerProductId;

    protected LifeBrokerApplyRequest(Builder builder) {
        applicants = builder.applicants;
        contactDetails = builder.contactDetails;
        partnerProductId = builder.partnerProductId;
    }
    protected LifeBrokerApplyRequest() {
    }

    public Applicants getApplicants() {
        return applicants;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }


    public Optional<String> getPartnerProductId() {
        return Optional.ofNullable(partnerProductId);
    }



    public static class Builder<T extends LifeBrokerApplyRequest.Builder> {
        private Applicants applicants;
        private ContactDetails contactDetails;
        private String partnerProductId;

        public Builder(LifeBrokerApplyRequest object) {
            applicants = object.getApplicants();
            contactDetails = object.getContactDetails();
            partnerProductId = object.getPartnerProductId().orElse(null);
        }

        public Builder() {
        }


        public T applicants(Applicants val) {
            applicants = val;
            return (T) this;
        }

        public T contactDetails(ContactDetails val) {
            contactDetails = val;
            return (T) this;
        }

        public T partnerProductId(String val) {
            partnerProductId = val;
            return (T) this;
        }

        public LifeBrokerApplyRequest build() {
            return new LifeBrokerApplyRequest(this);
        }
    }
}
