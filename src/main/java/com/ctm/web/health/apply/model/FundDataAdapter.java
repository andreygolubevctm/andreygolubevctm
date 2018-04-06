package com.ctm.web.health.apply.model;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.common.Relationship;
import com.ctm.web.health.apply.model.request.fundData.Declaration;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.fundData.ProductId;
import com.ctm.web.health.apply.model.request.fundData.Provider;
import com.ctm.web.health.apply.model.request.fundData.Referrer;
import com.ctm.web.health.apply.model.request.fundData.benefits.Benefits;
import com.ctm.web.health.apply.model.request.fundData.membership.*;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.*;
import com.ctm.web.health.model.form.*;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static java.util.Collections.emptyList;

public class FundDataAdapter {

    protected static FundData createFundData(Optional<HealthQuote> quote) {
        return new FundData(
                quote.map(HealthQuote::getApplication)
                        .map(Application::getProvider)
                        .map(Provider::new)
                        .orElse(null),
                quote.map(HealthQuote::getApplication)
                        .map(Application::getProductId)
                        .map(v -> StringUtils.substringAfter(v, "HEALTH-"))
                        .map(ProductId::new)
                        .orElse(null),
                Declaration.Y,
                quote.map(HealthQuote::getPayment)
                        .map(com.ctm.web.health.model.form.Payment::getDetails)
                        .map(PaymentDetails::getStart)
                        .map(LocalDateUtils::parseAUSLocalDate)
                        .orElse(null),
                createBenefits(quote),
                createMembership(quote),
                createReferrer(quote));
    }

    protected static Referrer createReferrer(Optional<HealthQuote> quote) {
        // Check WFD
        Optional<Referrer> referrer = quote.map(HealthQuote::getApplication)
                .map(Application::getWfd)
                .map(FundDataAdapter::createReferrer);

        return referrer.orElse(null);
    }

    protected static Membership createMembership(Optional<HealthQuote> quote) {
        // Check CBH
        Optional<Membership> membership = quote.map(HealthQuote::getApplication)
                .map(Application::getCbh)
                .map(FundDataAdapter::createMembership);
        // Check for Nhb
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getNhb)
                    .map(FundDataAdapter::createMembership);
        }
        // Check for Qtu
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getQtu)
                    .map(FundDataAdapter::createMembership);
        }
        // Check for Wfd
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getWfd)
                    .map(FundDataAdapter::createMembership);
        }

        // Check for Hif
        if (!membership.isPresent()) {
            membership = quote.map(HealthQuote::getApplication)
                    .map(Application::getHif)
                    .map(FundDataAdapter::createMembership);
        }

        return membership.orElse(null);
    }

    protected static Benefits createBenefits(Optional<HealthQuote> quote) {
        // Check HBF
        Optional<Benefits> benefits = quote.map(HealthQuote::getApplication)
                .map(Application::getHbf)
                .map(FundDataAdapter::createBenefits);

        if(!benefits.isPresent()){
            benefits = quote.map(HealthQuote::getApplication)
                    .map(Application::getBup)
                    .map(FundDataAdapter::createBenefits);
        }
        return benefits.orElse(null);
    }

    protected static Benefits createBenefits(Hbf theHbf) {
        Optional<Hbf> hbf = Optional.ofNullable(theHbf);

        List<String> benefits = hbf.map(Hbf::getFlexiextras)
                .map(f -> Arrays.asList(StringUtils.split(f, ",")))
                .orElse(emptyList());
        if (!benefits.isEmpty()) {
            return new Benefits(benefits);
        } else {
            return null;
        }
    }

    protected static Benefits createBenefits(Bup theBup) {
        Optional<Bup> bup = Optional.ofNullable(theBup);

        List<String> benefits = bup.map(Bup::getFlexiextras)
                .map(f -> Arrays.asList(StringUtils.split(f, ",")))
                .orElse(emptyList());
        if (!benefits.isEmpty()) {
            return new Benefits(benefits);
        } else {
            return null;
        }
    }

    protected static Membership createMembership(Cbh theCbh) {
        Optional<Cbh> cbh = Optional.ofNullable(theCbh);
        if (cbh.isPresent()) {
            final RegisteredMember registeredMember;
            final CurrentMember currentMember;
            final MembershipNumber membershipNumber;
            final MembershipGroup membershipGroup;
            if (cbh.map(Cbh::getCurrentemployee)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = RegisteredMember.PRIMARY;
                currentMember = CurrentMember.Y;
                membershipNumber = cbh.map(Cbh::getCurrentnumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getCurrentwork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else if (cbh.map(Cbh::getFormeremployee)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = RegisteredMember.PRIMARY;
                currentMember = CurrentMember.N;
                membershipNumber = cbh.map(Cbh::getFormernumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getFormerwork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else if (cbh.map(Cbh::getFamilymember)
                    .filter(s -> "Y".equals(s)).isPresent()) {
                registeredMember = cbh.map(Cbh::getFamilyrel)
                        .map(StringUtils::upperCase)
                        .map(RegisteredMember::valueOf)
                        .orElse(null);
                currentMember = null;
                membershipNumber = cbh.map(Cbh::getFamilynumber)
                        .map(MembershipNumber::new)
                        .orElse(null);
                membershipGroup = cbh.map(Cbh::getFamilywork)
                        .map(MembershipGroup::new)
                        .orElse(null);
            } else {
                registeredMember = null;
                currentMember = null;
                membershipNumber = null;
                membershipGroup = null;
            }

            return new Membership(
                    registeredMember,
                    currentMember,
                    membershipNumber,
                    membershipGroup,
                    createPartnerDetailsCBH(cbh),
                    cbh.map(Cbh::getRegister)
                            .map(RegisterForGroupServices::valueOf)
                            .orElse(null),
                    null);
        } else {
            return null;
        }
    }

    protected static Membership createMembership(Nhb theNhb) {
        Optional<Nhb> nhb = Optional.ofNullable(theNhb);
        if (nhb.isPresent()) {
            return new Membership(
                    null,
                    null,
                    null,
                    null,
                    createPartnerDetailsNHB(nhb),
                    null,
                    createEligibility(nhb));
        } else {
            return null;
        }
    }

    protected static Membership createMembership(Qtu theQtu) {
        Optional<Qtu> qtu = Optional.ofNullable(theQtu);
        if (qtu.isPresent()) {
            return new Membership(
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    createEligibilityQtu(qtu));
        } else {
            return null;
        }
    }

    protected static Eligibility createEligibilityQtu(Optional<Qtu> qtu) {
        if (qtu.isPresent()) {
            return Eligibility.newBuilder()
                    .eligibilityReasonID(
                            qtu.map(Qtu::getEligibility)
                            .map(EligibilityReasonID::new)
                            .orElse(null))
                    .eligibilitySubReasonID(
                        qtu.map(Qtu::getUnion)
                                .map(EligibilitySubReasonID::new)
                                .orElse(null))
                    .build();
        } else {
            return null;
        }
    }

    protected static Eligibility createEligibility(Optional<Nhb> nhb) {
        if (nhb.isPresent()) {
            return Eligibility.newBuilder()
                    // for v1
                    .nhbEligibilityReasonID(
                            nhb.map(Nhb::getEligibility)
                            .map(NhbEligibilityReasonID::fromValue)
                            .orElse(null))
                    .nhbEligibilitySubReasonID(
                            nhb.map(Nhb::getSubreason)
                            .map(NhbEligibilitySubReasonID::fromValue)
                            .orElse(null))
                    // for v2
                    .eligibilityReasonID(
                            nhb.map(Nhb::getEligibility)
                            .map(EligibilityReasonID::new)
                            .orElse(null))
                    .eligibilitySubReasonID(
                            nhb.map(Nhb::getSubreason)
                            .map(EligibilitySubReasonID::new)
                            .orElse(null))
                    .build();
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetailsCBH(Optional<Cbh> cbh) {
        if (cbh.isPresent()) {
            return new PartnerDetails(
                    cbh.map(Cbh::getPartnerrel)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    cbh.map(Cbh::getPartneremployee)
                            .map(SameGroupMember::valueOf)
                            .orElse(null),null);
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetailsNHB(Optional<Nhb> nhb) {
        if (nhb.isPresent()) {
            return new PartnerDetails(
                    nhb.map(Nhb::getPartnerrel)
                            .map(Relationship::fromCode)
                            .map(Relationship::toString)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    null, null);
        } else {
            return null;
        }
    }

    protected static Membership createMembership(Wfd theWfd) {
        Optional<Wfd> wfd = Optional.ofNullable(theWfd);
        if (wfd.isPresent()) {
            return new Membership(
                    null,
                    null,
                    null,
                    null,
                    createPartnerDetailsWFD(wfd),
                    null,
                    null);
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetailsWFD(Optional<Wfd> wfd) {
        if (wfd.isPresent()) {
            return new PartnerDetails(
                    wfd.map(Wfd::getPartnerrel)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    null, null);
        } else {
            return null;
        }
    }

    protected static Membership createMembership(Hif theHif) {
        Optional<Hif> hif = Optional.ofNullable(theHif);
        if (hif.isPresent()) {
            return new Membership(
                    null,
                    null,
                    null,
                    null,
                    createPartnerDetailsHIF(hif),
                    null,
                    null);
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetailsHIF(Optional<Hif> hif) {
        if (hif.isPresent()) {
            return new PartnerDetails(
                    hif.map(Hif::getPartnerrel)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    null,
                    hif.map(Hif::getPartnerAuthorityLevel)
                            .orElse(null));
        } else {
            return null;
        }
    }

    protected static Referrer createReferrer(Wfd theWfd) {
        Optional<Wfd> wfd = Optional.ofNullable(theWfd);
        if(wfd.isPresent()) {
            return createReferrerWFD(wfd);
        } else {
            return null;
        }
    }

    private static Referrer createReferrerWFD(Optional<Wfd> wfd) {
        if (wfd.isPresent()) {
            return new Referrer(
                    wfd.map(Wfd::getReferrer)
                            .map(Referrer::get)
                            .orElse(null)
            );
        } else {
            return null;
        }
    }
}
