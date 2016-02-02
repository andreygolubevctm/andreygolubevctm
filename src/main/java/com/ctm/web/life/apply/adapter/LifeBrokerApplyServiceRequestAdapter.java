package com.ctm.web.life.apply.adapter;

import com.ctm.life.apply.model.request.lifebroker.LifeBrokerApplyRequest;
import com.ctm.life.model.request.Applicants;
import com.ctm.life.model.request.ContactDetails;
import com.ctm.life.model.request.Gender;
import com.ctm.life.model.request.Partner;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.apply.model.request.LifeQuoteRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LifeBrokerApplyServiceRequestAdapter implements WebRequestAdapter<LifeApplyPostRequestPayload, LifeBrokerApplyRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeBrokerApplyServiceRequestAdapter.class);
    private final LifeQuoteRequest lifeQuoteRequest;

    public LifeBrokerApplyServiceRequestAdapter(LifeQuoteRequest lifeQuoteRequest) {
        this.lifeQuoteRequest = lifeQuoteRequest;
    }

    @Override
    public LifeBrokerApplyRequest adapt(LifeApplyPostRequestPayload energyApplyPostRequestPayload) {
        LOGGER.debug("energyApplyPostRequestPayload = {}", kv("payload", energyApplyPostRequestPayload));

        // Map LifeBrokerApplyRequest
        LifeBrokerApplyRequest.Builder lifeBrokerApplyRequestBuilder = new LifeBrokerApplyRequest.Builder();

        Applicants applicants = adaptApplicants();

        lifeBrokerApplyRequestBuilder.applicants(applicants);
        adaptContactDetails(lifeBrokerApplyRequestBuilder);
        lifeBrokerApplyRequestBuilder.partnerProductId(energyApplyPostRequestPayload.getPartner_product_id());

        return lifeBrokerApplyRequestBuilder.build();
    }

    private void adaptContactDetails(LifeBrokerApplyRequest.Builder lifeBrokerApplyRequestBuilder) {
        ContactDetails.Builder contactDetailsBuilder = ContactDetails.newBuilder();
        contactDetailsBuilder.email();
        contactDetailsBuilder.phoneNumber();
        contactDetailsBuilder.postCode();
        contactDetailsBuilder.state()
        ContactDetails contactDetails = contactDetailsBuilder.build();
        lifeBrokerApplyRequestBuilder.contactDetails(contactDetailsBuilder.build());
    }

    private Applicants adaptApplicants() {
        Applicants.Builder applicantsBuilder = Applicants.newBuilder();
        Partner.Builder partnerBuilder = new Partner.Builder();
        partnerBuilder.age(lifeQuoteRequest.getPartner().getAge());
        // partnerBuilder.coverDetails(lifeQuoteRequest.getPartner().getCoverDetails());
        partnerBuilder.dateOfBirth(lifeQuoteRequest.getPartner().getDob());
        partnerBuilder.firstName(lifeQuoteRequest.getPartner().getFirstName());
        partnerBuilder.gender(adaptGender());
        partnerBuilder.lastName(lifeQuoteRequest.getPartner().getLastname());
        applicantsBuilder.partner(partnerBuilder.build());
        applicantsBuilder.primary()
        return applicantsBuilder.build();
    }

    private Gender adaptGender() {
        return lifeQuoteRequest.getPartner().getGender().equals(Gender.MALE) ? Gender.MALE : Gender.FEMALE;
    }

    public String getProductId(LifeApplyPostRequestPayload model) {
        return model.getClient_product_id();
    }

}
