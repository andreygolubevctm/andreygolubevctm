package com.ctm.web.health.payment.authorise.model;

import com.ctm.web.health.model.results.HealthPaymentAuthoriseResult;
import com.ctm.web.health.payment.authorise.model.response.AuthorisePaymentResponseV2;
import com.ctm.web.health.payment.authorise.model.response.Status;

public class ResponseAdapterV2 {

    public static HealthPaymentAuthoriseResult adapt(AuthorisePaymentResponseV2 response) {
        final HealthPaymentAuthoriseResult result = new HealthPaymentAuthoriseResult();
        if (Status.AUTHORIZED.equals(response.getStatus())) {
            result.setSuccess(true);
            result.setRefId(response.getTokenisationReferenceId());
            result.setUrl(response.getTokenisationUrl());
            result.setSst(response.getSst());
        } else {
            result.setSuccess(false);
        }
        return result;
    }

}
