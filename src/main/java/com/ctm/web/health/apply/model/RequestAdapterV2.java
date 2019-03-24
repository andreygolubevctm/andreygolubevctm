package com.ctm.web.health.apply.model;

import com.ctm.healthcommon.abd.ABD;
import com.ctm.healthcommon.abd.CombinedAbdSummary;
import com.ctm.healthcommon.abd.IndividualAbdSummary;
import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.apply.model.request.fundData.FundData;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.Fund;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Person;
import com.ctm.web.health.model.form.PreviousFund;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.Optional;
import java.util.function.Function;

public class RequestAdapterV2 {

    public static HealthApplicationRequest adapt(HealthRequest healthRequest, String operator, String cid, String trialCampaign) {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest).map(HealthRequest::getQuote);


        FundData fundData = FundDataAdapter.createFundData(quote);
        HealthApplicationRequest.Builder healthApplicationRequest = HealthApplicationRequest.newBuilder()
                .contactDetails(ContactDetailsAdapter.createContactDetails(quote))
                .payment(PaymentAdapter.createPayment(quote))
                .fundData(fundData)
                .applicants(ApplicationGroupAdapter.createApplicationGroup(quote))
                .operator(operator)
                .cid(cid)
                .trialCampaign(trialCampaign);

        Function<Person, Optional<LocalDate>> lookupDateOfBirth = person -> Optional.of(person).map(Person::getDob).filter(StringUtils::isNotBlank).flatMap(ABD.safeParseDate);

        Optional<LocalDate> optionalPrimaryDob = quote.map(HealthQuote::getApplication).map(Application::getPrimary).flatMap(lookupDateOfBirth);
        Optional<LocalDate> policyStartDate = Optional.of(fundData).map(FundData::getStartDate);


        if (optionalPrimaryDob.isPresent() && policyStartDate.isPresent()) {
            LocalDate primaryDob = optionalPrimaryDob.get();
            LocalDate assessmentDate = policyStartDate.get();

            Optional<LocalDate> primaryPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPrimary).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);

            Optional<LocalDate> optionalPartnerDob = quote.map(HealthQuote::getApplication).map(Application::getPartner).flatMap(lookupDateOfBirth);
            Optional<LocalDate> partnerPreviousPolicyStartDate = Optional.of(healthRequest).map(HealthRequest::getHealth).map(HealthQuote::getPreviousfund).map(PreviousFund::getPartner).map(Fund::getAbdPolicyStart).flatMap(ABD.safeParseDate);


            IndividualAbdSummary primaryABDSummary = ABD.calculateAgeBasedDiscount(primaryDob, assessmentDate, primaryPreviousPolicyStartDate);
            Optional<IndividualAbdSummary> partnerABDSummary = optionalPartnerDob.map(dob -> ABD.calculateAgeBasedDiscount(dob, assessmentDate, partnerPreviousPolicyStartDate));

            CombinedAbdSummary combinedABD = ABD.combine(assessmentDate, primaryABDSummary, partnerABDSummary);

            healthApplicationRequest.abdSummary(combinedABD);
        }

        return healthApplicationRequest.build();
    }

}
