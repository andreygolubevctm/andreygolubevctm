package com.ctm.providers.health.healthpayment.authorise.model;

import com.ctm.model.health.results.HealthPaymentAuthoriseResult;
import com.ctm.providers.health.healthpayment.authorise.model.response.AuthorisePaymentQuote;
import com.ctm.providers.health.healthpayment.authorise.model.response.AuthorisePaymentResponse;
import com.ctm.providers.health.healthpayment.authorise.model.response.Status;

public class ResponseAdapter {

    public static HealthPaymentAuthoriseResult adapt(AuthorisePaymentResponse response) {
        final AuthorisePaymentQuote paymentAuthorise = response.getPayload().getQuotes().get(0);
        final HealthPaymentAuthoriseResult result = new HealthPaymentAuthoriseResult();
        if (Status.AUTHORIZED.equals(paymentAuthorise.getStatus())) {
            result.setSuccess(true);
            result.setRefId(paymentAuthorise.getTokenisationReferenceId());
            result.setUrl(paymentAuthorise.getTokenisationUrl());
            result.setSst(paymentAuthorise.getSst());
        } else {
            result.setSuccess(false);
        }
        return result;
    }

}
