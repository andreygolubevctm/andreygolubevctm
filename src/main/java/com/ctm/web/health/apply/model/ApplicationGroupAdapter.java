package com.ctm.web.health.apply.model;

import com.ctm.web.core.model.request.Gender;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.ApplicationGroup;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.application.GovernmentRebate.AGRBoolean;
import com.ctm.web.health.apply.model.request.application.GovernmentRebate.GovernmentRebateAcknowledgement;
import com.ctm.web.health.apply.model.request.application.applicant.Applicant;
import com.ctm.web.health.apply.model.request.application.applicant.CertifiedAgeEntry;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.Cover;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.EverHadCover;
import com.ctm.web.health.apply.model.request.application.applicant.healthCover.HealthCoverLoading;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.CancelOption;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.ConfirmCover;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.CoverType;
import com.ctm.web.health.apply.model.request.application.applicant.previousFund.MemberId;
import com.ctm.web.health.apply.model.request.application.common.*;
import com.ctm.web.health.apply.model.request.application.dependant.FullTimeStudent;
import com.ctm.web.health.apply.model.request.application.dependant.GraduationDate;
import com.ctm.web.health.apply.model.request.application.dependant.School;
import com.ctm.web.health.apply.model.request.application.dependant.SchoolId;
import com.ctm.web.health.apply.model.request.application.situation.HealthCoverCategory;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.ctm.web.health.model.form.*;

import java.util.List;
import java.util.Optional;

import static java.util.stream.Collectors.toList;

public class ApplicationGroupAdapter {

    public static ApplicationGroup createApplicationGroup(Optional<HealthQuote> quote) {
        return new ApplicationGroup(
                // Applicant
                createApplicant(
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getPrimary),
                        quote.map(HealthQuote::getPreviousfund)
                                .map(com.ctm.web.health.model.form.PreviousFund::getPrimary),
                        quote.map(HealthQuote::getPrimaryCAE),
                        quote.map(HealthQuote::getHealthCover)
                                .map(com.ctm.web.health.model.form.HealthCover::getPrimary),
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getHif)
                                .map(Hif::getPrimaryemigrate)
                                .map(Emigrate::valueOf)
                                .orElse(null),
                        quote.map(HealthQuote::getPrimaryLHC),
                        quote.map(HealthQuote::getSituation)
                ),

                quote.map(HealthQuote::getApplication)
                        .map(Application::getPartner).map(Person::getTitle).isPresent()
                        ? createApplicant(
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getPartner),
                        quote.map(HealthQuote::getPreviousfund)
                                .map(com.ctm.web.health.model.form.PreviousFund::getPartner),
                        quote.map(HealthQuote::getPartnerCAE),
                        quote.map(HealthQuote::getHealthCover)
                                .map(com.ctm.web.health.model.form.HealthCover::getPartner),
                        quote.map(HealthQuote::getApplication)
                                .map(Application::getHif)
                                .map(Hif::getPartneremigrate)
                                .map(Emigrate::valueOf)
                                .orElse(null),quote.map(HealthQuote::getPartnerLHC),
                        quote.map(HealthQuote::getSituation)
                ) : null,

                createDependants(quote.map(HealthQuote::getApplication)
                        .map(Application::getDependants)),

                createSituation(quote.map(HealthQuote::getSituation)),

                quote.map(HealthQuote::getApplication)
                        .map(Application::getQch)
                        .map(Qch::getEmigrate)
                        .map(Emigrate::valueOf)
                        .orElse(null),

                createGovernmentRebateAck(quote.map(HealthQuote::getApplication)
                        .map(Application::getGovtRebateDeclaration))
        );
    }


    protected static GovernmentRebateAcknowledgement createGovernmentRebateAck(final Optional<GovtRebateDeclaration> govtRebateDeclaration) {
        final GovernmentRebateAcknowledgement governmentRebateAcknowledgement = govtRebateDeclaration.map(governmentRebateDeclaration -> {
            return new GovernmentRebateAcknowledgement(
                    govtRebateDeclaration.map(GovtRebateDeclaration::getApplicantCovered)
                            .map(AGRBoolean::valueOf)
                            .orElse(null),
                    govtRebateDeclaration.map(GovtRebateDeclaration::getEntitledToMedicare)
                            .map(AGRBoolean::valueOf)
                            .orElse(null),
                    govtRebateDeclaration.map(GovtRebateDeclaration::getDeclaration)
                            .map(AGRBoolean::valueOf)
                            .orElse(null),
                    govtRebateDeclaration.map(GovtRebateDeclaration::getDeclarationDate)
                            .map(LocalDateUtils::parseISOLocalDate)
                            .orElse(null),
                    govtRebateDeclaration.map(GovtRebateDeclaration::getVoiceConsent)
                            .map(AGRBoolean::valueOf)
                            .orElse(null),
                    govtRebateDeclaration.map(GovtRebateDeclaration::getChildOnlyPolicy)
                            .map(AGRBoolean::valueOf)
                            .orElse(null));
        }).orElseGet(() -> {
            return null;
        });
        return governmentRebateAcknowledgement;
    }


    protected static com.ctm.web.health.apply.model.request.application.situation.Situation createSituation(Optional<com.ctm.web.health.model.form.Situation> situation) {
        if (situation.isPresent()) {
            return new com.ctm.web.health.apply.model.request.application.situation.Situation(
                    situation.map(com.ctm.web.health.model.form.Situation::getHealthCvr)
                            .map(HealthCoverCategory::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Applicant createApplicant(Optional<Person> person, Optional<Fund> previousFund, Optional<Integer> certifiedAgeEntry, Optional<Insured> insured, Emigrate emigrate,Optional<Integer> lhcPercentage, Optional<Situation> situation) {
        if (person.isPresent()) {
            return new Applicant(
                    person.map(Person::getTitle)
                            .map(Title::findByCode)
                            .orElse(null),
                    person.map(Person::getFirstname)
                            .map(FirstName::new)
                            .orElse(null),
                    person.map(Person::getSurname)
                            .map(LastName::new)
                            .orElse(null),
                    person.map(Person::getGender)
                            .map(Gender::valueOf)
                            .orElse(null),
                    person.map(Person::getDob)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null),
                    insured.map(i -> new com.ctm.web.health.apply.model.request.application.applicant.healthCover.HealthCover(
                            Optional.ofNullable(i.getCover())
                                    .map(Cover::valueOf)
                                    .orElse(null),
                            Optional.ofNullable(i.getHealthCoverLoading())
                                    .map(HealthCoverLoading::valueOf)
                                    .orElse(null),
                            Optional.ofNullable(i.getEverHadCover())
                                    .map(EverHadCover::valueOf)
                                    .orElse(null)))
                            .orElse(null),
                    createPreviousFund(
                            previousFund,
                            person.map(Person::getCover),
                            situation.map(Situation::getCoverType),
                            insured.map(Insured::getHealthEverHeld)
                    ),
                    certifiedAgeEntry
                            .map(CertifiedAgeEntry::new)
                            .orElse(null),
                    person.map(Person::getAuthority)
                            .map(Authority::valueOf)
                            .orElse(null),
                    person.map(Person::getEmail)
                            .map(Email::new)
                            .orElse(null),
                    emigrate, lhcPercentage.orElse(0));
        }
        return null;
    }

    protected static List<com.ctm.web.health.apply.model.request.application.dependant.Dependant> createDependants(Optional<Dependants> dependants) {
        if (dependants.isPresent()) {
            return dependants.get()
                    .getDependant()
                    .stream()
                    .filter(d -> d != null && d.getLastname() != null)
                    .map(d -> createDependant(Optional.ofNullable(d)))
                    .collect(toList());
        } else {
            return null;
        }
    }

    protected static com.ctm.web.health.apply.model.request.application.dependant.Dependant createDependant(Optional<com.ctm.web.health.model.form.Dependant> dependant) {
        if (dependant.isPresent()) {
            return new com.ctm.web.health.apply.model.request.application.dependant.Dependant(
                    dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                            .map(Title::findByCode)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getFirstName)
                            .map(FirstName::new)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getLastname)
                            .map(LastName::new)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getDob)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchool)
                            .map(School::new)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getGraduationDate)
                            .map(GraduationDate::new)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolDate)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolID)
                            .map(SchoolId::new)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                            .map(Title::findByCode)
                            .filter(t -> t == Title.MR)
                            .map(v -> Gender.M)
                            .orElse(Gender.F),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getFulltime)
                            .map(FullTimeStudent::valueOf)
                            .orElse(null),
                    dependant.map(com.ctm.web.health.model.form.Dependant::getRelationship)
                            .map(Relationship::fromCode)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund createPreviousFund(Optional<Fund> previousFund, Optional<com.ctm.web.health.model.form.Cover> cover, Optional<String> purchaseType, Optional<String> healthEverHeld) {
        final HealthFund healthFund = previousFund.map(Fund::getFundName)
                .map(HealthFund::findByCode)
                .orElse(HealthFund.NONE);

        if (previousFund.isPresent() && !HealthFund.NONE.equals(healthFund)) {
            return new com.ctm.web.health.apply.model.request.application.applicant.previousFund.PreviousFund(
                    // The fund name, i.e "AAPI"
                    healthFund,

                    // The member Id, i.e "123654"
                    previousFund.map(Fund::getMemberID)
                        .map(MemberId::new)
                        .orElse(null),

                    // I don't actually know what this is to be honest
                    ConfirmCover.Y,
                    previousFund.map(Fund::getAuthority)
                        .map(Authority::valueOf)
                        .orElse(null),

                    // The type of cover, one of "H", "E" or "C". Optional
                    // This attribute comes from the xpath "/health/application/{person}/cover/type" so that has to be passed
                    cover.map(com.ctm.web.health.model.form.Cover::getType)
                        .map(CoverType::fromCode) // Map the string to enum
                        .orElse(    // If the user was not prompted to select cover type
                            healthEverHeld.map(CoverType::fromHealthEverHeld)   // Derive from 'healthEverHeld'
                                .orElse(null)   // If all else fails, use a null (WILL THROW ERROR, this should never be reached)
                        ),

                    // What is being cancelled on the previous fund, one of "C", "H", "E" or "N"
                    previousFund.map(Fund::getFundCancellationType) // Try getting the attribute from xpath "health/previousFund/{applicant}/fundCancellationType"
                        .map(CancelOption::fromCancellationType)    // If we get it, convert it to it's appropriate CancelOption enum
                        .orElse(                                        // If we did not get it
                            purchaseType.map(CancelOption::fromPurchaseType)    // Try deriving the CancelOption from the purchase type
                                .orElse(null)                     // If all else fails, we use a null (NOTE: this will be rejected from `health-apply` and this server will throw an error before reaching this), but it makes Java happy
                        )
            );
        } else {
            return null;
        }
    }
}
