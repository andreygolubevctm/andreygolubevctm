package com.ctm.web.life.adapter;

import com.ctm.life.model.request.Applicants;
import com.ctm.life.model.request.Gender;
import com.ctm.life.model.request.Partner;
import com.ctm.life.model.request.SmokerStatus;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.life.apply.model.request.LifeApplyWebRequest;
import com.ctm.web.life.form.model.Applicant;
import com.ctm.web.life.form.model.ContactDetails;
import com.ctm.web.life.form.model.Insurance;

import java.util.Optional;

public class LifeServiceRequestAdapter {

    public static com.ctm.life.model.request.ContactDetails createContactDetails(ContactDetails contactDetails, Applicant primary) {
        return com.ctm.life.model.request.ContactDetails.newBuilder()
                .email(contactDetails.getEmail())
                .phoneNumber(contactDetails.getContactNumber())
                .postCode(primary.getPostCode())
                .state(primary.getState())
                .build();
    }

    private static <T extends com.ctm.life.model.request.ApplicantBuilder> T setApplicantBuilder(T applicantBuilder, com.ctm.web.life.form.model.Applicant applicant) {
        applicantBuilder
                .firstName(applicant.getFirstName())
                .lastName(applicant.getLastname())
                .dateOfBirth(applicant.getDob())
                .age(applicant.getAge())
                .gender(getGender(applicant.getGender()))
                .smokerStatus(getSmokingStatus(applicant))
                .occupation(applicant.getOccupation())
                .occupationTitle(applicant.getOccupationTitle())
                .occupationGroup(applicant.getHannover());
        return applicantBuilder;
    }

    private static com.ctm.life.model.request.SmokerStatus getSmokingStatus(com.ctm.web.life.form.model.Applicant person) {
        return YesNo.getYesNoBoolean(person.getSmoker()) ? com.ctm.life.model.request.SmokerStatus.SMOKER : com.ctm.life.model.request.SmokerStatus.NON_SMOKER;
    }

    private static com.ctm.life.model.request.Gender getGender(com.ctm.web.life.form.model.Gender gender) {
        switch (gender) {
            case M: return com.ctm.life.model.request.Gender.MALE;
            case F: return com.ctm.life.model.request.Gender.FEMALE;
            default:
                throw new IllegalArgumentException("Not supported Gender " + gender);
        }
    }

    private static SmokerStatus adaptSmokerStatus(com.ctm.web.life.form.model.Applicant person) {
        return YesNo.getYesNoBoolean(person.getSmoker()) ? SmokerStatus.SMOKER : SmokerStatus.NON_SMOKER;
    }

    private static Gender adaptGender(com.ctm.web.life.form.model.Applicant lifePerson) {
        return com.ctm.web.core.model.request.Gender.M.equals(lifePerson.getGender()) ? Gender.MALE : Gender.FEMALE;
    }

    public String getProductId(LifeApplyWebRequest model) {
        return model.getClient_product_id();
    }

    public static Applicants getApplicants(Applicant primary , Applicant partner) {
        final Applicants.Builder builder = Applicants.newBuilder()
                .primary(createApplicant(primary, primary.getInsurance()));
        Optional.ofNullable(partner)
                .ifPresent(p -> builder.partner(createPartner(p, primary)));
        return builder.build();
    }


    private static com.ctm.life.model.request.Applicant createApplicant(com.ctm.web.life.form.model.Applicant applicant, Insurance insurance) {
        return setApplicantBuilder(com.ctm.life.model.request.Applicant.newBuilder(), applicant)
                .coverDetails(createCoverDetails(insurance))
                .build();
    }

    private static com.ctm.life.model.request.Partner createPartner(com.ctm.web.life.form.model.Applicant partner, com.ctm.web.life.form.model.Applicant primary) {
        final Partner.Builder builder = setApplicantBuilder(Partner.newPartnerBuilder(), partner);
        final Insurance primaryInsurance = primary.getInsurance();
        if(YesNo.getYesNoBoolean(primaryInsurance.getSamecover())){
            builder.sameCoverDetailsAsPrimary(true);
        } else {
            builder.sameCoverDetailsAsPrimary(false)
                    .coverDetails(createCoverDetails(partner.getInsurance()));
        }
        return builder.build();
    }

    private static com.ctm.life.model.request.CoverDetails createCoverDetails(Insurance insurance) {
        return com.ctm.life.model.request.CoverDetails.newBuilder()
                .frequency(insurance.getFrequency())
                .type(insurance.getType())
                .termLifeCover(insurance.getTerm())
                .totalAndPermanentDisabilityCover(insurance.getTpd())
                .totalAndPermanentDisabilityAnyOwn(insurance.getTpdanyown())
                .traumaCover(insurance.getTrauma())
                .build();
    }

}
