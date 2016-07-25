package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;

import java.util.Optional;

public class RequestAdapterV2 {

    public static HealthApplicationRequest adapt(HealthRequest healthRequest) {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest.getQuote());
        return HealthApplicationRequest.instanceOfV2(
                ContactDetailsAdapter.createContactDetails(quote),
                PaymentAdapter.createPayment(quote),
                FundDataAdapter.createFundData(quote),
                ApplicationGroupAdapter.createApplicationGroup(quote));
    }

}
