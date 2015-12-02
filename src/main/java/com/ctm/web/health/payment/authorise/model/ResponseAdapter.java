package com.ctm.web.health.payment.authorise.model;

import com.ctm.web.health.model.results.HealthPaymentAuthoriseResult;
import com.ctm.web.health.payment.authorise.model.response.AuthorisePaymentQuote;
import com.ctm.web.health.payment.authorise.model.response.AuthorisePaymentResponse;
import com.ctm.web.health.payment.authorise.model.response.Status;

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
