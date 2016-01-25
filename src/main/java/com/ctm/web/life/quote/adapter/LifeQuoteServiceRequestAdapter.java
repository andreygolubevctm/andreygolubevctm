package com.ctm.web.life.quote.adapter;

import com.ctm.life.quote.model.request.*;
import com.ctm.life.quote.model.request.ContactDetails;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import com.ctm.web.life.form.model.*;
import com.ctm.web.life.form.model.Applicant;
import com.ctm.web.life.form.model.Gender;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class LifeQuoteServiceRequestAdapter implements WebRequestAdapter<LifeQuoteWebRequest, LifeQuoteRequest> {

    @Override
    public LifeQuoteRequest adapt(LifeQuoteWebRequest request) {
        return LifeQuoteRequest.newBuilder()
                .applicants(createApplicants(request.getQuote()))
                .contactDetails(createContactDetails(request.getQuote()))
                .build();
    }

    private ContactDetails createContactDetails(LifeQuote quote) {
        return ContactDetails.newBuilder()
                .email(quote.getContactDetails().getEmail())
                .phoneNumber(quote.getContactDetails().getContactNumber())
                .postCode(quote.getPrimary().getPostCode())
                .state(quote.getPrimary().getState())
                .build();
    }

    private Applicants createApplicants(LifeQuote quote) {
        final Applicants.Builder builder = Applicants.newBuilder()
                .primary(createApplicant(quote.getPrimary(), quote.getPrimary().getInsurance()));
        Optional.ofNullable(quote.getPartner())
                .ifPresent(p -> builder.partner(createPartner(p, quote.getPrimary())));
        return builder.build();
    }

    private com.ctm.life.quote.model.request.Partner createPartner(Applicant partner, Applicant primary) {
        final Partner.Builder builder = setApplicantBuilder(Partner.newPartnerBuilder(), partner);
        final Insurance primaryInsurance = primary.getInsurance();
        if ("Y".equals(primaryInsurance.getSamecover())) {
            builder.sameCoverDetailsAsPrimary(true);
        } else {
            builder.sameCoverDetailsAsPrimary(false)
                    .coverDetails(createCoverDetails(partner.getInsurance()));
        }
        return builder.build();
    }

    private com.ctm.life.quote.model.request.Applicant createApplicant(Applicant applicant, Insurance insurance) {
        return setApplicantBuilder(com.ctm.life.quote.model.request.Applicant.newBuilder(), applicant)
                .coverDetails(createCoverDetails(insurance))
                .build();
    }

    private <T extends ApplicantBuilder> T setApplicantBuilder(T applicantBuilder, Applicant applicant) {
        applicantBuilder
                .firstName(applicant.getFirstName())
                .lastName(applicant.getLastname())
                .dateOfBirth(applicant.getDob())
                .age(applicant.getAge())
                .gender(getGender(applicant.getGender()))
                .smokerStatus(getSmokingStatus(applicant.getSmoker()))
                .occupation(applicant.getOccupation())
                .occupationTitle(applicant.getOccupationTitle())
                .occupationGroup(applicant.getHannover());
        return applicantBuilder;
    }

    private com.ctm.life.quote.model.request.Gender getGender(Gender gender) {
        switch (gender) {
            case M: return com.ctm.life.quote.model.request.Gender.MALE;
            case F: return com.ctm.life.quote.model.request.Gender.FEMALE;
            default:
                throw new IllegalArgumentException("Not supported Gender " + gender);
        }
    }

    private SmokerStatus getSmokingStatus(Smoker smoker) {
        switch (smoker) {
            case N: return SmokerStatus.NON_SMOKER;
            case Y: return SmokerStatus.SMOKER;
            default:
                throw new IllegalArgumentException("Not supported SmokingStatus " + smoker);
        }
    }

    private CoverDetails createCoverDetails(Insurance insurance) {
        return CoverDetails.newBuilder()
                .frequency(insurance.getFrequency())
                .type(insurance.getType())
                .termLifeCover(insurance.getTerm())
                .totalAndPermanentDisabilityCover(insurance.getTpd())
                .totalAndPermanentDisabilityAnyOwn(insurance.getTpdanyown())
                .traumaCover(insurance.getTrauma())
                .build();
    }
}
