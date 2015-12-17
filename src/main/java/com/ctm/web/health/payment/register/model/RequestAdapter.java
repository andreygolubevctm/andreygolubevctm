package com.ctm.web.health.payment.register.model;

import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.payment.register.model.request.RegisterPaymentRequest;

import java.util.Collections;

public class RequestAdapter {

    public static RegisterPaymentRequest adapt(HealthRegisterPaymentRequest data) {
        final RegisterPaymentRequest request = new RegisterPaymentRequest();
        request.setProviderFilter(Collections.singletonList(data.getProviderId()));
        request.setSst(data.getSst());
        request.setReferenceId(data.getSessionId());
        request.setMaskedCardNumber(data.getMaskedcardno());
        request.setCardType(data.getCardType());
        request.setToken(data.getToken());
        request.setResponseCode(data.getResponsecode());
        request.setResponseResult(data.getResponseresult());
        return request;
    }

}
