package com.ctm.web.health.apply.model;

import com.ctm.healthcommon.abd.ABD;
import com.ctm.healthcommon.abd.CombinedAbdSummary;
import com.ctm.healthcommon.abd.IndividualAbdSummary;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.apply.model.request.product.PriceResultExtraInfo;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.results.HealthQuoteResult;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.Optional;
import java.util.function.Function;

public class RequestAdapterV2 {

    static final String PAYMENT_TYPE_BANK = "ba";
    static final String BANK_ACCOUNT = "BankAccount";
    static final String CREDIT_CARD = "CreditCard";

    public static HealthApplicationRequest adapt(HealthRequest healthRequest, HealthQuoteResult healthSelectedProduct,
                                                 String operator, String cid, String trialCampaign) throws DaoException {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest).map(HealthRequest::getQuote);

        Optional<String> bankPaymentType = quote.map(HealthQuote::getPayment).map(Payment::getDetails).map(PaymentDetails::getType).filter(PAYMENT_TYPE_BANK::equals);
        final String paymentType = bankPaymentType.isPresent() ? BANK_ACCOUNT : CREDIT_CARD;
        String fundProductCode = healthSelectedProduct.getInfo().getFundProductCode();
        String extrasName = healthSelectedProduct.getInfo().getExtrasName();
        String hospitalName = healthSelectedProduct.getInfo().getHospitalName();
        int excess = healthSelectedProduct.getInfo().getExcess();

        FundData fundData = FundDataAdapter.createFundData(quote);
        PriceResultExtraInfo product = ProductAdapter.createProduct(healthSelectedProduct, fundProductCode, paymentType, extrasName, hospitalName, excess);

        HealthApplicationRequest.Builder healthApplicationRequest = HealthApplicationRequest.newBuilder()
                .contactDetails(ContactDetailsAdapter.createContactDetails(quote))
                .payment(PaymentAdapter.createPayment(quote))
                .fundData(fundData)
                .applicants(ApplicationGroupAdapter.createApplicationGroup(quote))
                .product(product)
                .operator(operator)
                .cid(cid)
                .trialCampaign(trialCampaign);

        Function<Person, Optional<LocalDate>> lookupDateOfBirth = person -> Optional.of(person).map(Person::getDob).filter(StringUtils::isNotBlank).flatMap(ABD.safeParseDate);

        Optional<LocalDate> optionalPrimaryDob = quote.map(HealthQuote::getApplication).map(Application::getPrimary).flatMap(lookupDateOfBirth);
        Optional<LocalDate> policyStartDate = Optional.of(fundData).map(FundData::getStartDate);


        if (optionalPrimaryDob.isPresent() && policyStartDate.isPresent()) {
            LocalDate primaryDob = optionalPrimaryDob.get();
            LocalDate assessmentDate = policyStartDate.get();

            boolean isSimples = StringUtils.isNotBlank(operator);
            final Optional<LocalDate> primaryPreviousPolicyStartDate;

            if (isSimples) {
                primaryPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getHealthCover).map(HealthCover::getPrimary).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            } else {
                primaryPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPrimary).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            }

            Optional<LocalDate> optionalPartnerDob = quote.map(HealthQuote::getApplication).map(Application::getPartner).flatMap(lookupDateOfBirth);

            final Optional<LocalDate> partnerPreviousPolicyStartDate;

            if (isSimples) {
                partnerPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getHealthCover).map(HealthCover::getPartner).map(Insured::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            } else {
                partnerPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPartner).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);
            }

            IndividualAbdSummary primaryABDSummary = ABD.calculateAgeBasedDiscount(primaryDob, assessmentDate, primaryPreviousPolicyStartDate);
            Optional<IndividualAbdSummary> partnerABDSummary = optionalPartnerDob.map(dob -> ABD.calculateAgeBasedDiscount(dob, assessmentDate, partnerPreviousPolicyStartDate));

            CombinedAbdSummary combinedABD = ABD.combine(assessmentDate, primaryABDSummary, partnerABDSummary);

            healthApplicationRequest.abdSummary(combinedABD);
        }

        return healthApplicationRequest.build();
    }

}
