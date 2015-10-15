package com.ctm.providers.health.healthpayment.register.model;

import com.ctm.model.health.results.HealthRegisterPaymentResult;
import com.ctm.providers.health.healthpayment.register.model.response.RegisterPaymentQuote;
import com.ctm.providers.health.healthpayment.register.model.response.RegisterPaymentResponse;
import com.ctm.providers.health.healthpayment.register.model.response.Status;

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
