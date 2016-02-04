package com.ctm.web.life.apply.adapter;

import com.ctm.life.model.request.*;
import com.ctm.life.model.request.ContactDetails;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.model.request.*;

public class LifeBrokerServiceRequestAdapter {



    public static ContactDetails getContactDetails(LifeRequest lifeQuoteRequest) {
        ContactDetails.Builder contactDetailsBuilder = ContactDetails.newBuilder();
        contactDetailsBuilder.email(lifeQuoteRequest.getContactDetails().getEmail());
        contactDetailsBuilder.phoneNumber(lifeQuoteRequest.getContactDetails().getContactNumber());
        contactDetailsBuilder.postCode(lifeQuoteRequest.getPrimary().getPostCode());
        contactDetailsBuilder.state(lifeQuoteRequest.getPrimary().getState());
        return contactDetailsBuilder.build();
    }

    public static Applicants getApplicants(LifeRequest lifeQuoteRequest) {
        Applicants.Builder applicantsBuilder = Applicants.newBuilder();

        Primary primary = lifeQuoteRequest.getPrimary();
        PrimaryInsurance primaryInsurance = primary.getInsurance();
        CoverDetails coverDetailsPrimary = createCoverDetails(primaryInsurance);
        ApplicantBuilder primaryBuilder = new ApplicantBuilder();
        setSharedPersonFields(lifeQuoteRequest, primaryBuilder, primary);
        primaryBuilder.coverDetails(coverDetailsPrimary);
        applicantsBuilder.primary(primaryBuilder.build());

        Partner.Builder partnerBuilder = new Partner.Builder();
        LifePerson partner = lifeQuoteRequest.getPartner();
        setSharedPersonFields(lifeQuoteRequest, partnerBuilder, partner);
        if(YesNo.getYesNoBoolean(primaryInsurance.getSamecover())){
            partnerBuilder.coverDetails(coverDetailsPrimary);
        } else {
            partnerBuilder.coverDetails(createCoverDetails(partner.getInsurance()));
        }
        applicantsBuilder.partner(partnerBuilder.build());
        return applicantsBuilder.build();
    }

    private static CoverDetails createCoverDetails(Insurance insurance) {
        CoverDetails.Builder coverDetailsBuilder = CoverDetails.newBuilder();
        coverDetailsBuilder.frequency(insurance.getFrequency());
        coverDetailsBuilder.termLifeCover(insurance.getTerm());
        coverDetailsBuilder.totalAndPermanentDisabilityAnyOwn(insurance.getTpdanyown());
        coverDetailsBuilder.totalAndPermanentDisabilityCover(insurance.getTpd());
        coverDetailsBuilder.traumaCover(insurance.getTrauma());
        coverDetailsBuilder.type(insurance.getType());
        return coverDetailsBuilder.build();
    }

    private static void setSharedPersonFields(LifeRequest lifeQuoteRequest, ApplicantBuilder builder, LifePerson person) {
        builder.age(person.getAge());
        builder.dateOfBirth(person.getDob());
        builder.firstName(person.getFirstName());
        builder.gender(adaptGender(lifeQuoteRequest));
        builder.lastName(person.getLastname());
    }

    private static Gender adaptGender(LifeRequest lifeQuoteRequest) {
        return lifeQuoteRequest.getPartner().getGender().equals(Gender.MALE) ? Gender.MALE : Gender.FEMALE;
    }

    public String getProductId(LifeApplyPostRequestPayload model) {
        return model.getClient_product_id();
    }

}
