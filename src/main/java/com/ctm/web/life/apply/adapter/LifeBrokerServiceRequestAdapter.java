package com.ctm.web.life.apply.adapter;

import com.ctm.life.model.request.*;
import com.ctm.life.model.request.ContactDetails;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.model.request.*;

public class LifeBrokerServiceRequestAdapter {

    public static ContactDetails getContactDetails(com.ctm.web.life.model.request.ContactDetails lifeQuoteRequest,
                                                   Primary primary) {
        ContactDetails.Builder contactDetailsBuilder = ContactDetails.newBuilder();
        contactDetailsBuilder.email(lifeQuoteRequest.getEmail());
        contactDetailsBuilder.phoneNumber(lifeQuoteRequest.getContactNumber());
        contactDetailsBuilder.postCode(primary.getPostCode());
        contactDetailsBuilder.state(primary.getState());
        return contactDetailsBuilder.build();
    }

    public static Applicants getApplicants(Primary primary, LifePerson partner) {
        Applicants.Builder applicantsBuilder = Applicants.newBuilder();

        PrimaryInsurance primaryInsurance = primary.getInsurance();
        CoverDetails coverDetailsPrimary = createCoverDetails(primaryInsurance);
        ApplicantBuilder primaryBuilder = new ApplicantBuilder();
        setSharedPersonFields(primaryBuilder, primary);
        primaryBuilder.coverDetails(coverDetailsPrimary);
        applicantsBuilder.primary(primaryBuilder.build());

        if(YesNo.getYesNoBoolean(primaryInsurance.getPartner())) {
            getPartner(applicantsBuilder, primaryInsurance, coverDetailsPrimary, partner);
        }
        return applicantsBuilder.build();
    }

    private static void getPartner(Applicants.Builder applicantsBuilder, PrimaryInsurance primaryInsurance, CoverDetails coverDetailsPrimary, LifePerson partner) {
        Partner.Builder partnerBuilder = new Partner.Builder();
        setSharedPersonFields(partnerBuilder, partner);
        if(YesNo.getYesNoBoolean(primaryInsurance.getSamecover())){
            partnerBuilder.coverDetails(coverDetailsPrimary);
        } else {
            partnerBuilder.coverDetails(createCoverDetails(partner.getInsurance()));
        }
        applicantsBuilder.partner(partnerBuilder.build());
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

    private static void setSharedPersonFields( ApplicantBuilder builder, LifePerson person) {
        builder.age(person.getAge());
        builder.dateOfBirth(person.getDob());
        builder.firstName(person.getFirstName());
        builder.gender(adaptGender(person));
        builder.lastName(person.getLastname())
                .occupation(person.getOccupation())
                .occupationGroup(person.getHannover()).smokerStatus(adaptSmokerStatus(person));
    }

    private static SmokerStatus adaptSmokerStatus(LifePerson person) {
        return YesNo.getYesNoBoolean(person.getSmoker()) ? SmokerStatus.SMOKER : SmokerStatus.NON_SMOKER;
    }

    private static Gender adaptGender(LifePerson lifePerson) {
        return com.ctm.web.core.model.request.Gender.M.equals(lifePerson.getGender()) ? Gender.MALE : Gender.FEMALE;
    }

    public String getProductId(LifeApplyPostRequestPayload model) {
        return model.getClient_product_id();
    }

}
