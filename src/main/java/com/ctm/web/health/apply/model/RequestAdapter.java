package com.ctm.web.health.apply.model;

import com.ctm.web.health.apply.model.request.HealthApplicationRequest;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;

import java.util.Collections;
import java.util.Optional;

import static java.util.Collections.emptyList;

public class RequestAdapter {

    public static HealthApplicationRequest adapt(HealthRequest healthRequest) {
        final Optional<HealthQuote> quote = Optional.ofNullable(healthRequest.getQuote());
        return new HealthApplicationRequest(
                ContactDetailsAdapter.createContactDetails(quote),
                PaymentAdapter.createPayment(quote),
                FundDataAdapter.createFundData(quote),
                ApplicationGroupAdapter.createApplicationGroup(quote),
                quote.map(HealthQuote::getApplication)
                    .map(Application::getProvider)
                    .map(Collections::singletonList)
                        .orElse(emptyList()));
    }

}
