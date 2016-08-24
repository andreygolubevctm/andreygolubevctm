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
        return HealthApplicationRequest.newBuilder()
                .contactDetails(ContactDetailsAdapter.createContactDetails(quote))
                .payment(PaymentAdapter.createPayment(quote))
                .fundData(FundDataAdapter.createFundData(quote))
                .applicants(ApplicationGroupAdapter.createApplicationGroup(quote))
                .providerFilter(quote.map(HealthQuote::getApplication)
                    .map(Application::getProvider)
                    .map(Collections::singletonList)
                        .orElse(emptyList()))
                .build();
    }

}
