package com.ctm.web.health.payment.authorise.model;

import com.ctm.web.health.model.form.HealthAuthorisePaymentRequest;
import com.ctm.web.health.payment.authorise.model.request.AuthorisePaymentRequest;

import java.util.Collections;

public class RequestAdapter {

    public static AuthorisePaymentRequest adapt(HealthAuthorisePaymentRequest data) {
        final AuthorisePaymentRequest request = new AuthorisePaymentRequest();
        request.setProviderFilter(Collections.singletonList(data.getProviderId()));
        request.setReturnUrl(data.getReturnUrl());
        return request;
    }

}
