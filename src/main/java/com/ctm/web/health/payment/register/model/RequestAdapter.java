package com.ctm.web.health.payment.register.model;

import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.payment.register.model.request.RegisterPaymentRequest;

public class RequestAdapter {

    //HAM-17 when web_ctm sends empty string as ResponseResult, the payload Health Apply receives doesn't have the  ResponseResult field.
    //Hence, doing this as I don't have an explanation for why it's happening.
    //ToDo Further investigation on finding the reason behind this behaviour
    public static final String RESPONSE_RESULT = "AUTHORISED";

    public static RegisterPaymentRequest adapt(HealthRegisterPaymentRequest data) {
        final RegisterPaymentRequest request = new RegisterPaymentRequest();
        request.setSst(data.getSst());
        request.setReferenceId(data.getSessionid());
        request.setMaskedCardNumber(data.getMaskedcardno());
        request.setCardType(data.getCardtype());
        request.setToken(data.getToken());
        request.setResponseCode(data.getResponsecode());
        request.setResponseResult((data.getResponseresult() != null && "".equals(data.getResponseresult()))? RESPONSE_RESULT : data.getResponseresult());
        return request;
    }

}
