package com.ctm.web.health.payment.register.model;

import com.ctm.web.health.model.results.HealthRegisterPaymentResult;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentQuote;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentResponse;
import com.ctm.web.health.payment.register.model.response.Status;

public class ResponseAdapter {

    public static HealthRegisterPaymentResult adapt(final RegisterPaymentResponse response) {
        final RegisterPaymentQuote registerPayment = response.getPayload().getQuotes().get(0);

        final HealthRegisterPaymentResult result = new HealthRegisterPaymentResult();
        if (Status.REGISTERED.equals(registerPayment.getStatus())) {
            result.setSuccess(true);
        } else {
            result.setSuccess(false);
        }
        return result;
    }

}
