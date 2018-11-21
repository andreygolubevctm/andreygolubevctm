package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;

import java.util.Optional;

public class RequestAdapterV2 {

    public static HealthApplicationRequest adapt(HealthRequest healthRequest, String operator, String cid, String trialCampaign) {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest.getQuote());
        return HealthApplicationRequest.newBuilder()
                .contactDetails(ContactDetailsAdapter.createContactDetails(quote))
                .payment(PaymentAdapter.createPayment(quote))
                .fundData(FundDataAdapter.createFundData(quote))
                .applicants(ApplicationGroupAdapter.createApplicationGroup(quote))
                .operator(operator)
                .cid(cid)
                .trialCampaign(trialCampaign)
                .build();
    }

}
