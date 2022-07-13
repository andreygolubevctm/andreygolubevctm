package com.ctm.web.health.apply.model;

import com.ctm.healthcommon.abd.ABD;
import com.ctm.healthcommon.abd.CombinedAbdSummary;
import com.ctm.healthcommon.abd.IndividualAbdSummary;
import com.ctm.schema.health.v1_0_0.AgeBasedDiscountSummary;
import com.ctm.schema.health.v1_0_0.ApplyRequest;
import com.ctm.schema.health.v1_0_0.PolicyType;
import com.ctm.schema.health.v1_0_0.ProductDetails;
import com.ctm.schema.health.v1_0_0.ProviderDetails;
import com.ctm.schema.health.v1_0_0.ProviderPayload;
import com.ctm.schema.whitelabel.v1_0_0.Whitelabel;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.apply.model.request.application.common.Relationship;
import com.ctm.web.health.apply.model.request.payment.details.PaymentType;
import com.ctm.web.health.exceptions.HealthApplyServiceException;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.HealthCover;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Insured;
import com.ctm.web.health.model.form.Payment;
import com.ctm.web.health.model.form.PaymentDetails;
import com.ctm.web.health.model.form.Person;
import com.ctm.web.health.model.form.PreviousFund;
import com.ctm.web.health.model.results.HealthQuoteResult;
import com.google.common.collect.ImmutableMap;
import org.apache.commons.lang3.StringUtils;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.UUID;
import java.util.function.Function;

public class RequestAdapter {

    private static final String BANK_ACCOUNT = "BankAccount";
    private static final String CREDIT_CARD = "CreditCard";
    private static final ZoneId AEST_ZONE_ID = ZoneId.of("Australia/Brisbane");
    private static final ZoneId UTC_ZONE_ID = ZoneId.of("UTC");
    protected static final String YES_INDICATOR = "Y";

    protected static final ImmutableMap<Relationship, com.ctm.schema.health.v1_0_0.RelationshipToPrimary> RELATIONSHIP_MAP = ImmutableMap.<Relationship, com.ctm.schema.health.v1_0_0.RelationshipToPrimary>builder()
            .put(Relationship.Baby, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.BABY)
            .put(Relationship.Dtr, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.DAUGHTER)
            .put(Relationship.FDtr, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.FOSTER_DAUGHTER)
            .put(Relationship.Fson, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.FOSTER_SON)
            .put(Relationship.Membr, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.PRIMARY)
            .put(Relationship.Other, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.OTHER_ADULT_DEPENDANT)
            .put(Relationship.Ptnr, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.PARTNER)
            .put(Relationship.Son, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.SON)
            .put(Relationship.Sps, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.SPOUSE)
            .put(Relationship.NONE, com.ctm.schema.health.v1_0_0.RelationshipToPrimary.NONE)
            .build();

    protected static final ImmutableMap<String, PolicyType> POLICY_TYPE_MAP = ImmutableMap.<String, PolicyType>builder()
            .put("C", PolicyType.COMBINED)
            .put("H", PolicyType.HOSPITAL)
            .put("E", PolicyType.ANCILLARY)
            .put("A", PolicyType.ANCILLARY)
            .build();

    protected static PolicyType getPolicyTypeFromHealthEverHeld(final String healthEverHeld) {
        if(healthEverHeld.equals("Y")) {
            return PolicyType.HOSPITAL;  // Return the HOSPITAL/"H" enum
        }
        return null;
    }

    public static ApplyRequest adapt(HealthRequest healthRequest, HealthQuoteResult healthSelectedProduct,
                                     String operator, String cid, String trialCampaign, String brandCode) throws DaoException, HealthApplyServiceException {

        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest).map(HealthRequest::getQuote);

        String providerCode = quote.map(q -> q.getApplication().getProvider()).orElseThrow(() -> new HealthApplyServiceException("Provider Code cannot be null"));
        ZonedDateTime requestAt = Optional.ofNullable(healthRequest.getRequestAt())
                .map(d -> ZonedDateTime.of(d, AEST_ZONE_ID).withZoneSameInstant(UTC_ZONE_ID))
                .orElse(Instant.now().atZone(UTC_ZONE_ID));
        Whitelabel whitelabel = Whitelabel.valueOf(brandCode.toUpperCase());
        UUID productId = UUID.fromString(healthSelectedProduct.getProductId());

        return new ApplyRequest()
                .withJourneyId(healthSelectedProduct.getJourneyId())
                .withProductId(productId)
                .withProviderCode(providerCode)
                .withQuoteId(healthSelectedProduct.getQuoteId())
                .withRequestedAt(requestAt)
                .withTransactionId(healthRequest.getTransactionId())
                .withWhitelabel(whitelabel)
                .withProviderPayload(getProviderPayload(healthRequest, quote, healthSelectedProduct, operator));
    }

    private static ProviderPayload getProviderPayload(final HealthRequest healthRequest, final Optional<HealthQuote> quote, final HealthQuoteResult healthSelectedProduct, final String operator) throws HealthApplyServiceException {
        final ProviderDetails providerDetails = ProviderDetailsAdapter.createProviderDetails(quote);
        return new ProviderPayload()
                .withContactDetails(ContactDetailsAdapter.createContactDetails(quote))
                .withPayment(PaymentAdapter.createPayment(quote))
                .withProviderDetails(providerDetails)
                .withApplicants(ApplicantsAdapter.createApplicants(quote))
                .withProductDetails(getProductDetails(quote, healthSelectedProduct))
                .withAgeBasedDiscountSummary(getAgeBasedDiscountSummary(healthRequest, quote, providerDetails, operator))
                .withSimplesUserId(operator);
    }

    private static ProductDetails getProductDetails(final Optional<HealthQuote> quote, final HealthQuoteResult healthSelectedProduct) {
        Optional<String> bankPaymentType = quote.map(HealthQuote::getPayment).map(Payment::getDetails).map(PaymentDetails::getType).filter(PaymentType.BANK.getCode()::equals);
        final String paymentType = bankPaymentType.isPresent() ? BANK_ACCOUNT : CREDIT_CARD;
        String fundProductCode = healthSelectedProduct.getInfo().getFundProductCode();
        String extrasName = healthSelectedProduct.getInfo().getExtrasName();
        String hospitalName = healthSelectedProduct.getInfo().getHospitalName();
        int excess = healthSelectedProduct.getInfo().getExcess();
        return ProductAdapter.createProduct(healthSelectedProduct, fundProductCode, paymentType, extrasName, hospitalName, excess);
    }

    private static AgeBasedDiscountSummary getAgeBasedDiscountSummary(final HealthRequest healthRequest, final Optional<HealthQuote> quote, final ProviderDetails providerDetails, final String operator) {

        Function<Person, Optional<LocalDate>> lookupDateOfBirth = person -> Optional.of(person).map(Person::getDob).filter(StringUtils::isNotBlank).flatMap(ABD.safeParseDate);
        Optional<LocalDate> optionalPrimaryDob = quote.map(HealthQuote::getApplication).map(Application::getPrimary).flatMap(lookupDateOfBirth);
        Optional<LocalDate> policyStartDate = Optional.of(providerDetails).map(ProviderDetails::getPolicyStartDate);

        if (optionalPrimaryDob.isPresent() && policyStartDate.isPresent()) {
            final LocalDate primaryDob = optionalPrimaryDob.get();
            final LocalDate assessmentDate = policyStartDate.get();
            boolean isSimples = StringUtils.isNotBlank(operator);
            final Optional<LocalDate> primaryPreviousPolicyStartDate;

            if (isSimples) {
                primaryPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getHealthCover).map(HealthCover::getPrimary).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            } else {
                primaryPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPrimary).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            }

            final Optional<LocalDate> optionalPartnerDob = quote.map(HealthQuote::getApplication).map(Application::getPartner).flatMap(lookupDateOfBirth);
            final Optional<LocalDate> partnerPreviousPolicyStartDate;

            if (isSimples) {
                partnerPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getHealthCover).map(HealthCover::getPartner).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            } else {
                partnerPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPartner).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            }

            final IndividualAbdSummary primaryABDSummary = ABD.calculateAgeBasedDiscount(primaryDob, assessmentDate, primaryPreviousPolicyStartDate);
            final Optional<IndividualAbdSummary> partnerABDSummary = optionalPartnerDob.map(dob -> ABD.calculateAgeBasedDiscount(dob, assessmentDate, partnerPreviousPolicyStartDate));
            final CombinedAbdSummary combinedABD = ABD.combine(assessmentDate, primaryABDSummary, partnerABDSummary);

            return new AgeBasedDiscountSummary()
                    .withAgeBasedDiscount(combinedABD.getAbd())
                    .withRetainedAgeBasedDiscount(combinedABD.getRabd())
                    .withAssessmentDate(assessmentDate)
                    .withPrimary(getIndividualAbdSummary(Optional.of(primaryABDSummary)))
                    .withPartner(getIndividualAbdSummary(partnerABDSummary));
        } else {
            return null;
        }
    }

    private static com.ctm.schema.health.v1_0_0.IndividualAbdSummary getIndividualAbdSummary(final Optional<IndividualAbdSummary> abdSummary) {
        return abdSummary.map(abd -> new com.ctm.schema.health.v1_0_0.IndividualAbdSummary()
                        .withCurrentAge(abd.getCurrentAge())
                        .withAgeBasedDiscount(new com.ctm.schema.health.v1_0_0.AgeBasedDiscount()
                                .withPercentage(abd.getAgeBasedDiscount().getPercentage())
                                .withAssessmentDate(abd.getAgeBasedDiscount().getAssessmentDate())
                                .withCertifiedDiscountAge(abd.getAgeBasedDiscount().getCertifiedDiscountAge()))
                        .withRetainedAgeBasedDiscount(new com.ctm.schema.health.v1_0_0.RetainedAgeBasedDiscount()
                                .withPercentage(abd.getRetainedAgeBasedDiscount().getPercentage())
                                .withAssessmentDate(abd.getRetainedAgeBasedDiscount().getAssessmentDate())
                                .withCertifiedDiscountAge(abd.getRetainedAgeBasedDiscount().getCertifiedDiscountAge())
                                .withOriginalAgeBasedDiscount(abd.getRetainedAgeBasedDiscount().getOriginalAgeBasedDiscount())
                                .withRetainedAgeBasedDiscountReduction(abd.getRetainedAgeBasedDiscount().getRetainedAgeBasedDiscountReduction())
                                .withIsAbdCurrentlyRetained(abd.getRetainedAgeBasedDiscount().isABDCurrentlyRetained())))
                .orElse(null);

    }
}


