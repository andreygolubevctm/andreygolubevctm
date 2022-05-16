package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.Applicant;
import com.ctm.schema.health.v1_0_0.Applicants;
import com.ctm.schema.health.v1_0_0.CurrentFund;
import com.ctm.schema.health.v1_0_0.HealthCoverHistory;
import com.ctm.schema.health.v1_0_0.MembershipType;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.Emigrate;
import com.ctm.web.health.apply.model.request.application.common.Relationship;
import com.ctm.web.health.apply.model.request.application.common.Title;
import com.ctm.web.health.apply.model.request.fundData.HealthFund;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Dependants;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.GovtRebateDeclaration;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Hif;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.form.Person;
import com.ctm.web.health.model.form.Situation;
import com.google.common.collect.ImmutableMap;

import java.util.List;
import java.util.Optional;

import static java.util.stream.Collectors.toList;

public class ApplicantsAdapter {

    private static final ImmutableMap<String, MembershipType> MEMBERSHIP_TYPE_MAP = ImmutableMap.<String, MembershipType>builder()
            .put("SM", MembershipType.SINGLE)
            .put("SF", MembershipType.SINGLE)
            .put("S", MembershipType.SINGLE)
            .put("C", MembershipType.COUPLE)
            .put("F", MembershipType.FAMILY)
            .put("SP", MembershipType.SINGLE_PARENT_FAMILY)
            .put("SPF", MembershipType.SINGLE_PARENT_FAMILY)
            .put("EF", MembershipType.EXTENDED_FAMILY)
            .put("ESP", MembershipType.EXTENDED_SINGLE_PARENT_FAMILY)
            .build();

    private static final ImmutableMap<String, com.ctm.schema.health.v1_0_0.Gender> GENDER_MAP = ImmutableMap.<String, com.ctm.schema.health.v1_0_0.Gender>builder()
            .put("M", com.ctm.schema.health.v1_0_0.Gender.MALE)
            .put("F", com.ctm.schema.health.v1_0_0.Gender.FEMALE)
            .build();

    public static Applicants createApplicants(Optional<HealthQuote> quote) {
        return new Applicants()
                .withMembershipType(createMembershipType(quote.map(HealthQuote::getSituation)))
                .withPrimaryApplicant(
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
                                quote.map(HealthQuote::getSituation),
                                quote.map(HealthQuote::getApplication)
                                        .map(Application::getEmail)))
                .withPartnerApplicant(quote.map(HealthQuote::getApplication)
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
                                .orElse(null), quote.map(HealthQuote::getPartnerLHC),
                        quote.map(HealthQuote::getSituation),
                        Optional.empty()
                ) : null)
                .withDependants(createDependants(quote.map(HealthQuote::getApplication)
                        .map(Application::getDependants)))
                .withIsClaimingGovernmentRebate(quote.map(HealthQuote::getApplication)
                        .map(Application::getGovtRebateDeclaration)
                        .map(GovtRebateDeclaration::getDeclaration)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false)
                )
                .withGovernmentRebateAcknowledgement(createGovernmentRebateAck(quote.map(HealthQuote::getApplication)
                        .map(Application::getGovtRebateDeclaration)));
    }


    protected static com.ctm.schema.health.v1_0_0.GovernmentRebateAcknowledgement createGovernmentRebateAck(final Optional<GovtRebateDeclaration> govtRebateDeclaration) {
        return govtRebateDeclaration.map(governmentRebateDeclaration -> new com.ctm.schema.health.v1_0_0.GovernmentRebateAcknowledgement()
                        .withApplicantCovered(govtRebateDeclaration.map(GovtRebateDeclaration::getApplicantCovered)
                                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                                .orElse(false))
                        .withAreAllApplicantsEntitledToMedicare(govtRebateDeclaration.map(GovtRebateDeclaration::getEntitledToMedicare)
                                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                                .orElse(false))
                        .withChildOnlyPolicy(govtRebateDeclaration.map(GovtRebateDeclaration::getChildOnlyPolicy)
                                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                                .orElse(false))
                        .withDeclarationDate(govtRebateDeclaration.map(GovtRebateDeclaration::getDeclarationDate)
                                .map(LocalDateUtils::parseISOLocalDate)
                                .orElse(null))
                        .withVoiceConsent(govtRebateDeclaration.map(GovtRebateDeclaration::getVoiceConsent)
                                .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                                .orElse(false)))
                .orElse(null);
    }

    protected static MembershipType createMembershipType(Optional<com.ctm.web.health.model.form.Situation> situation) {
        if (situation.isPresent()) {
            return situation.map(com.ctm.web.health.model.form.Situation::getHealthCvr)
                    .map(String::toUpperCase)
                    .map(MEMBERSHIP_TYPE_MAP::get)
                    .orElse(null);
        } else {
            return null;
        }
    }

    protected static Applicant createApplicant(Optional<Person> person, Optional<Fund> previousFund, Optional<Integer> certifiedAgeEntry, Optional<Insured> insured, Emigrate emigrate, Optional<Integer> lhcPercentage, Optional<Situation> situation, Optional<String> email) {
        if (person.isPresent()) {
            return new Applicant()
                    .withFirstName(person.map(Person::getFirstname).orElse(null))
                    .withLastName(person.map(Person::getSurname).orElse(null))
                    .withTitle(person.map(Person::getTitle)
                            .map(String::toUpperCase)
                            .map(com.ctm.schema.health.v1_0_0.Title::fromValue)
                            .orElse(null))
                    .withDateOfBirth(person.map(Person::getDob)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null))
                    .withGender(person.map(Person::getGender)
                            .map(GENDER_MAP::get)
                            .orElse(null))
                    .withEmail(person.map(Person::getEmail)
                            .orElse(email.orElse(null)))
                    .withCertifiedAgeEntry(certifiedAgeEntry.orElse(null))
                    .withIsRecentImmigrant(Optional.ofNullable(emigrate)
                            .map(Emigrate::name)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(null))
                    .withLhcPercentage(lhcPercentage.orElse(0))
                    .withIsPartnerGivenAuthority(person.map(Person::getAuthority)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(false))
                    .withHealthCoverHistory(createHealthCoverHistory(insured, previousFund, person, situation));
        }
        return null;
    }

    protected static HealthCoverHistory createHealthCoverHistory(Optional<Insured> insured, Optional<Fund> previousFund, Optional<Person> person, Optional<Situation> situation) {
        return new HealthCoverHistory()
                .withHasCurrentHealthCover(insured.map(Insured::getCover)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false))
                .withEverHadCover(insured.map(Insured::getEverHadCover)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false))
                .withIsLHCLoadingApplied(insured.map(Insured::getHealthCoverLoading)
                        .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                        .orElse(false))
                .withCurrentFund(createCurrentFund(previousFund,
                        person,
                        situation.map(Situation::getCoverType), insured))
//                .withHasHadContinuousCover()  // TODO - not currently used by health-apply service
//                .withDifferentProvidersForHospitalAndExtrasCover() // TODO - not currently used by health-apply service
//                .withPriorCoverPeriods()  // TODO - not currently used by health-apply service
                ;
    }

    protected static List<com.ctm.schema.health.v1_0_0.Dependant> createDependants(Optional<Dependants> dependants) {
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

    protected static com.ctm.schema.health.v1_0_0.Dependant createDependant(Optional<com.ctm.web.health.model.form.Dependant> dependant) {
        if (dependant.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Dependant()
                    .withTitle(dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                            .map(String::toUpperCase)
                            .map(com.ctm.schema.health.v1_0_0.Title::fromValue)
                            .orElse(null))
                    .withFirstName(dependant.map(com.ctm.web.health.model.form.Dependant::getFirstName).orElse(null))
                    .withLastName(dependant.map(com.ctm.web.health.model.form.Dependant::getLastname).orElse(null))
                    .withGender(dependant.map(com.ctm.web.health.model.form.Dependant::getTitle)
                            .map(Title::findByCode)
                            .filter(Title.MR::equals)
                            .map(v -> com.ctm.schema.health.v1_0_0.Gender.MALE)
                            .orElse(com.ctm.schema.health.v1_0_0.Gender.FEMALE))
                    .withDateOfBirth(dependant.map(com.ctm.web.health.model.form.Dependant::getDob)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null))
                    .withRelationship(dependant.map(com.ctm.web.health.model.form.Dependant::getRelationship)
                            .map(Relationship::fromCode)
                            .map(RequestAdapter.RELATIONSHIP_MAP::get)
                            .orElse(null))
                    .withIsFullTimeStudent(dependant.map(com.ctm.web.health.model.form.Dependant::getFulltime)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(false))
                    .withSchoolName(dependant.map(com.ctm.web.health.model.form.Dependant::getSchool).orElse(null))
                    .withSchoolStartDate(dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolDate)
                            .map(LocalDateUtils::parseAUSLocalDate)
                            .orElse(null))
                    .withGraduationDate(dependant.map(com.ctm.web.health.model.form.Dependant::getGraduationDate)
                            .map(LocalDateUtils::parseISOLocalDate)
                            .orElse(null))
                    .withStudentID(dependant.map(com.ctm.web.health.model.form.Dependant::getSchoolID).orElse(null));
        } else {
            return null;
        }
    }

    protected static CurrentFund createCurrentFund(Optional<Fund> previousFund, Optional<Person> person, Optional<String> purchaseType, Optional<Insured> insured) {
        final HealthFund healthFund = previousFund.map(Fund::getFundName)
                .map(HealthFund::findByCode)
                .orElse(HealthFund.NONE);
        //for Simples apply
        Optional<String> healthEverHeld = insured.map(Insured::getHealthEverHeld);
        if (!healthEverHeld.isPresent()) {
            //for Online apply
            healthEverHeld = person.map(Person::getEverHadCoverPrivateHospital1);
        }
        Optional<com.ctm.web.health.model.form.Cover> cover = person.map(Person::getCover);
        boolean currentCovered = false;
        if (insured.isPresent() && "Y".equalsIgnoreCase(insured.get().getCover())) {
            currentCovered = true;
        }
        if ( previousFund.isPresent() && !HealthFund.NONE.equals(healthFund)
                && ((!currentCovered && healthEverHeld.isPresent() && "Y".equals(healthEverHeld.get()))
                || currentCovered)) {
            return new CurrentFund()
                    // FIXME - confirm this is the provider code
                    .withProviderCode(healthFund.name())
                    .withMembershipNumber(previousFund.map(Fund::getMemberID).orElse(null))
                    .withPolicyType(cover.map(com.ctm.web.health.model.form.Cover::getType)
                            .map(RequestAdapter.POLICY_TYPE_MAP::get)
                            .orElse(null))
                    .withHasAuthorityToContactFund(previousFund.map(Fund::getAuthority)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(false))
                    .withCancelOption(previousFund.map(Fund::getFundCancellationType) // Try getting the attribute from xpath "health/previousFund/{applicant}/fundCancellationType"
                            .filter(RequestAdapter.POLICY_TYPE_MAP::containsKey)  // filter out any FundCancellationType == N ie Nothing to be cancelled - these will be passed as null
                            .map(RequestAdapter.POLICY_TYPE_MAP::get)    // If we get it, convert it to it's appropriate PolicyType enum
                            .orElse(                                        // If we did not get it
                                    purchaseType
                                            .filter(RequestAdapter.POLICY_TYPE_MAP::containsKey) // filter out any purchaseType == N ie Nothing to be cancelled - these will be passed as null
                                            .map(RequestAdapter.POLICY_TYPE_MAP::get)    // Try deriving the CancelOption from the purchase type
                                            .orElse(null)                     // If all else fails, we use a null (NOTE: this will be rejected from `health-apply` and this server will throw an error before reaching this), but it makes Java happy
                            ));
        } else {
            return null;
        }
    }
}
