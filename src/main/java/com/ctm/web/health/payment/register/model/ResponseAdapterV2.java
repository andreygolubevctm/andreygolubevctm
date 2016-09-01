package com.ctm.web.health.payment.register.model;

import com.ctm.web.health.model.results.HealthRegisterPaymentResult;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentResponseV2;
import com.ctm.web.health.payment.register.model.response.Status;

public class ResponseAdapterV2 {

    public static HealthRegisterPaymentResult adapt(final RegisterPaymentResponseV2 response) {
        final HealthRegisterPaymentResult result = new HealthRegisterPaymentResult();
        if (Status.REGISTERED.equals(response.getStatus())) {
            result.setSuccess(true);
        } else {
            result.setSuccess(false);
        }
        return result;
    }

}
