package com.ctm.web.health.apply.model;

import com.ctm.schema.health.v1_0_0.AuthorityLevel;
import com.ctm.schema.health.v1_0_0.ProviderDetails;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.common.Relationship;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Bup;
import com.ctm.web.health.model.form.Cbh;
import com.ctm.web.health.model.form.Hbf;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.Hif;
import com.ctm.web.health.model.form.Nhb;
import com.ctm.web.health.model.form.PaymentDetails;
import com.ctm.web.health.model.form.Qtu;
import com.ctm.web.health.model.form.Wfd;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static java.util.Collections.emptyList;

public class ProviderDetailsAdapter {

    private static final ImmutableMap<String, AuthorityLevel> AUTHORITY_LEVEL_MAP = ImmutableMap.<String, AuthorityLevel>builder()
            .put("Y", AuthorityLevel.FULL)
//            .put("", AuthorityLevel.CLAIMS_ONLY)  // this value has been added as a future requirement for the health journey - not currently used
            .put("N", AuthorityLevel.NO_AUTHORITY)
            .build();

    protected static ProviderDetails createProviderDetails(final Optional<HealthQuote> quote) {
        return new ProviderDetails()
                .withBenefits(createBenefits(quote))
                .withHeardAbout(createHeardAbout(quote))
                .withMembership(createMembership(quote))
                .withFundJoinDeclarationConfirmation(true)
                .withPolicyStartDate(quote.map(HealthQuote::getPayment)
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(LocalDateUtils::parseAUSLocalDate)
                        .orElse(null));
    }

    protected static String createHeardAbout(Optional<HealthQuote> quote) {
        // Check WFD
        return quote.map(HealthQuote::getApplication)
                .map(Application::getWfd)
                .map(ProviderDetailsAdapter::createHeardAbout)
                .orElse(null);
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Optional<HealthQuote> quote) {
        // Check CBH
        Optional<com.ctm.schema.health.v1_0_0.Membership> membership = quote.map(HealthQuote::getApplication)
                .map(Application::getCbh)
                .map(ProviderDetailsAdapter::createMembership);
        // Check for Nhb
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getNhb)
                    .map(ProviderDetailsAdapter::createMembership);
        }
        // Check for Qtu
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getQtu)
                    .map(ProviderDetailsAdapter::createMembership);
        }
        // Check for Wfd
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getWfd)
                    .map(ProviderDetailsAdapter::createMembership);
        }

        // Check for Hif
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getHif)
                    .map(ProviderDetailsAdapter::createMembership);
        }

        // Check for Uhf
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getUhf)
                    .map(ProviderDetailsAdapter::createMembership);
        }

        return membership.orElse(null);
    }

    protected static List<String> createBenefits(Optional<HealthQuote> quote) {
        // Check HBF
        List<String> benefits = quote.map(HealthQuote::getApplication)
                .map(Application::getHbf)
                .map(ProviderDetailsAdapter::createBenefits)
                .orElse(null);

        if (benefits == null) {
            benefits = quote.map(HealthQuote::getApplication)
                    .map(Application::getBup)
                    .map(ProviderDetailsAdapter::createBenefits)
                    .orElse(null);
        }
        return benefits;
    }

    protected static List<String> createBenefits(Hbf theHbf) {
        return Optional.ofNullable(theHbf)
                .map(Hbf::getFlexiextras)
                .map(f -> Arrays.asList(StringUtils.split(f, ",")))
                .orElse(null);
    }

    protected static List<String> createBenefits(Bup theBup) {
        return Optional.ofNullable(theBup)
                .map(Bup::getFlexiextras)
                .map(f -> Arrays.asList(StringUtils.split(f, ",")))
                .orElse(emptyList());
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Cbh theCbh) {
        Optional<Cbh> cbh = Optional.ofNullable(theCbh);
        if (cbh.isPresent()) {
            final com.ctm.schema.health.v1_0_0.RelationshipToMember registeredMember;
            final Boolean currentMember;
            final String membershipNumber;
            final String membershipGroup;
            if (cbh.map(Cbh::getCurrentemployee)
                    .filter(RequestAdapter.YES_INDICATOR::equals).isPresent()) {
                registeredMember = com.ctm.schema.health.v1_0_0.RelationshipToMember.PRIMARY;
                currentMember = true;
                membershipNumber = cbh.map(Cbh::getCurrentnumber).orElse(null);
                membershipGroup = cbh.map(Cbh::getCurrentwork).orElse(null);
            } else if (cbh.map(Cbh::getFormeremployee)
                    .filter(RequestAdapter.YES_INDICATOR::equals).isPresent()) {
                registeredMember = com.ctm.schema.health.v1_0_0.RelationshipToMember.PRIMARY;
                currentMember = false;
                membershipNumber = cbh.map(Cbh::getFormernumber).orElse(null);
                membershipGroup = cbh.map(Cbh::getFormerwork).orElse(null);
            } else if (cbh.map(Cbh::getFamilymember)
                    .filter(RequestAdapter.YES_INDICATOR::equals).isPresent()) {
                registeredMember = cbh.map(Cbh::getFamilyrel)
                        .map(StringUtils::upperCase)
                        .map(com.ctm.schema.health.v1_0_0.RelationshipToMember::fromValue)
                        .orElse(null);
                currentMember = null;
                membershipNumber = cbh.map(Cbh::getFamilynumber).orElse(null);
                membershipGroup = cbh.map(Cbh::getFamilywork).orElse(null);
            } else {
                registeredMember = null;
                currentMember = null;
                membershipNumber = null;
                membershipGroup = null;
            }

            return new com.ctm.schema.health.v1_0_0.Membership()
                    .withIsACurrentMember(currentMember)
                    .withMembershipNumber(membershipNumber)
                    .withMembershipGroup(membershipGroup)
                    .withRegisteredMember(registeredMember)
                    .withPartnerDetails(createPartnerDetailsCBH(cbh))
                    .withRegisterForGroupServices(cbh.map(Cbh::getRegister)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(false))
                    ;
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Nhb theNhb) {
        Optional<Nhb> nhb = Optional.ofNullable(theNhb);
        if (nhb.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Membership()
                    .withPartnerDetails(createPartnerDetailsNHB(nhb))
                    .withEligibility(createEligibility(nhb));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Qtu theQtu) {
        Optional<Qtu> qtu = Optional.ofNullable(theQtu);
        if (qtu.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Membership()
                    .withEligibility(createEligibilityQtu(qtu));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Eligibility createEligibilityQtu(Optional<Qtu> qtu) {
        if (qtu.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Eligibility()
                    .withReason(qtu.map(Qtu::getEligibility).orElse(null))
                    .withSubReason(qtu.map(Qtu::getUnion).orElse(null));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Eligibility createEligibility(Optional<Nhb> nhb) {
        if (nhb.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Eligibility()
                    .withReason(nhb.map(Nhb::getEligibility).orElse(null))
                    .withSubReason(nhb.map(Nhb::getSubreason).orElse(null));
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.PartnerDetails createPartnerDetailsCBH(Optional<Cbh> cbh) {
        if (cbh.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.PartnerDetails()
                    .withRelationshipToPrimary(cbh.map(Cbh::getPartnerrel)
                            .map(Relationship::fromCode)
                            .map(RequestAdapter.RELATIONSHIP_MAP::get)
                            .orElse(null))
                    .withIsGroupMember(cbh.map(Cbh::getPartneremployee)
                            .map(RequestAdapter.YES_INDICATOR::equalsIgnoreCase)
                            .orElse(null));
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.PartnerDetails createPartnerDetailsNHB(Optional<Nhb> nhb) {
        if (nhb.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.PartnerDetails()
                    .withRelationshipToPrimary(nhb.map(Nhb::getPartnerrel)
                            .map(Relationship::fromCode)
                            .map(RequestAdapter.RELATIONSHIP_MAP::get)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Wfd theWfd) {
        Optional<Wfd> wfd = Optional.ofNullable(theWfd);
        if (wfd.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Membership()
                    .withPartnerDetails(createPartnerDetailsWFD(wfd));
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.PartnerDetails createPartnerDetailsWFD(Optional<Wfd> wfd) {
        if (wfd.isPresent()) {
            // FIXME test this
            return new com.ctm.schema.health.v1_0_0.PartnerDetails()
                    .withRelationshipToPrimary(wfd.map(Wfd::getPartnerrel)
                            .map(com.ctm.schema.health.v1_0_0.RelationshipToPrimary::valueOf)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static com.ctm.schema.health.v1_0_0.Membership createMembership(Hif theHif) {
        Optional<Hif> hif = Optional.ofNullable(theHif);
        if (hif.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.Membership()
                    .withPartnerDetails(createPartnerDetailsHIF(hif));
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.PartnerDetails createPartnerDetailsHIF(Optional<Hif> hif) {
        if (hif.isPresent()) {
            return new com.ctm.schema.health.v1_0_0.PartnerDetails()
                    .withRelationshipToPrimary(hif.map(Hif::getPartnerrel)
                            .map(Relationship::fromCode)
                            .map(RequestAdapter.RELATIONSHIP_MAP::get)
                            .orElse(null))
                    .withPartnerAuthorityLevel(hif.map(Hif::getPartnerAuthorityLevel)
                            .map(AUTHORITY_LEVEL_MAP::get)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static String createHeardAbout(Wfd theWfd) {
        return Optional.ofNullable(theWfd)
                .map(Wfd::getHeardAbout)
                .orElse(null);
    }
}
