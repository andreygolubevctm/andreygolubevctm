package com.ctm.web.health.payment.register.model;

import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.payment.register.model.request.RegisterPaymentRequest;

public class RequestAdapter {

    public static RegisterPaymentRequest adapt(HealthRegisterPaymentRequest data) {
        final RegisterPaymentRequest request = new RegisterPaymentRequest();
        request.setSst(data.getSst());
        request.setReferenceId(data.getSessionid());
        request.setMaskedCardNumber(data.getMaskedcardno());
        request.setCardType(data.getCardtype());
        request.setToken(data.getToken());
        request.setResponseCode(data.getResponsecode());
        request.setResponseResult(data.getResponseresult());
        return request;
    }

}
