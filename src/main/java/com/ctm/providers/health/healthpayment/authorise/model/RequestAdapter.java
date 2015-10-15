package com.ctm.providers.health.healthpayment.authorise.model;

import com.ctm.model.health.form.HealthAuthorisePaymentRequest;
import com.ctm.providers.health.healthpayment.authorise.model.request.AuthorisePaymentRequest;

import java.util.Collections;

public class RequestAdapter {

    public static AuthorisePaymentRequest adapt(HealthAuthorisePaymentRequest data) {
        final AuthorisePaymentRequest request = new AuthorisePaymentRequest();
        request.setProviderFilter(Collections.singletonList(data.getProviderId()));
        request.setReturnUrl(data.getReturnUrl());
        return request;
    }

}
