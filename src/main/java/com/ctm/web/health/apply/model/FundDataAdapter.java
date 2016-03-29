package com.ctm.web.health.apply.model;

import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.health.apply.model.request.application.common.Relationship;
import com.ctm.web.health.apply.model.request.application.situation.HealthSituation;
import com.ctm.web.health.apply.model.request.fundData.Declaration;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.fundData.ProductId;
import com.ctm.web.health.apply.model.request.fundData.Provider;
import com.ctm.web.health.apply.model.request.fundData.benefits.Benefits;
import com.ctm.web.health.apply.model.request.fundData.membership.*;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.Eligibility;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.EligibilityReasonID;
import com.ctm.web.health.apply.model.request.fundData.membership.eligibility.EligibilitySubReasonID;
import com.ctm.web.health.model.form.*;
import org.apache.commons.lang3.StringUtils;

import java.util.Optional;

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
                quote.map(HealthQuote::getSituation)
                        .map(com.ctm.web.health.model.form.Situation::getHealthSitu)
                        .map(v -> new Benefits(HealthSituation.valueOf(v)))
                        .orElse(null),
                quote.map(HealthQuote::getApplication)
                    .map(Application::getCbh)
                    .map(FundDataAdapter::createMembership)
                    .orElseGet(() -> quote.map(HealthQuote::getApplication)
                        .map(Application::getNav)
                        .map(FundDataAdapter::createMembership)
                        .orElse(null)));
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

    protected static Membership createMembership(Nav theNav) {
        Optional<Nav> nav = Optional.ofNullable(theNav);
        if (nav.isPresent()) {
            return new Membership(
                    null,
                    null,
                    null,
                    null,
                    createPartnerDetailsNAV(nav),
                    null,
                    createEligibility(nav));
        } else {
            return null;
        }
    }

    protected static Eligibility createEligibility(Optional<Nav> nav) {
        if (nav.isPresent()) {
            return new Eligibility(
                    nav.map(Nav::getEligibility)
                        .map(EligibilityReasonID::fromValue)
                        .orElse(null),
                    nav.map(Nav::getSubreason)
                        .map(EligibilitySubReasonID::fromValue)
                        .orElse(null));
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
                            .orElse(null));
        } else {
            return null;
        }
    }

    private static PartnerDetails createPartnerDetailsNAV(Optional<Nav> nav) {
        if (nav.isPresent()) {
            return new PartnerDetails(
                    nav.map(Nav::getPartnerrel)
                            .map(Relationship::fromCode)
                            .map(Relationship::toString)
                            .map(RelationshipToPrimary::new)
                            .orElse(null),
                    null);
        } else {
            return null;
        }
    }

}
