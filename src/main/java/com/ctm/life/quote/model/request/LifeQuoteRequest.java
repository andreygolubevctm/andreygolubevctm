package com.ctm.life.quote.model.request;


import com.ctm.interfaces.common.aggregator.request.QuoteRequest;
import com.ctm.life.model.request.Applicants;
import com.ctm.life.model.request.ContactDetails;
// import edu.umd.cs.findbugs.annotations.SuppressWarnings;

import javax.validation.constraints.NotNull;

public class LifeQuoteRequest implements QuoteRequest {

    @NotNull
    private Applicants applicants;

    @NotNull
    private ContactDetails contactDetails;

    // @SuppressWarnings("unused")
    private LifeQuoteRequest(){}

    private LifeQuoteRequest(Builder builder) {
        applicants = builder.applicants;
        contactDetails = builder.contactDetails;
    }

    public static Builder newBuilder() {
        return new Builder();
    }

    public Applicants getApplicants() {
        return applicants;
    }

    public ContactDetails getContactDetails() {
        return contactDetails;
    }


    public static final class Builder {
        private Applicants applicants;
        private ContactDetails contactDetails;

        private Builder() {
        }

        public Builder applicants(Applicants val) {
            applicants = val;
            return this;
        }

        public Builder contactDetails(ContactDetails val) {
            contactDetails = val;
            return this;
        }

        public LifeQuoteRequest build() {
            return new LifeQuoteRequest(this);
        }
    }
}
