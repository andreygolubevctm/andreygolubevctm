package com.ctm.web.health.services;


import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.health.model.form.HealthAuthorisePaymentRequest;
import com.ctm.web.health.model.results.HealthPaymentAuthoriseResult;
import com.ctm.web.health.payment.authorise.model.ResponseAdapter;
import com.ctm.web.health.payment.authorise.model.request.AuthorisePaymentRequest;
import com.ctm.web.health.payment.authorise.model.response.AuthorisePaymentResponse;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthAuthorisePaymentService extends CommonRequestService<AuthorisePaymentRequest, AuthorisePaymentResponse> {

    public HealthPaymentAuthoriseResult authorise(Brand brand, HealthAuthorisePaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final AuthorisePaymentRequest request = com.ctm.web.health.payment.authorise.model.RequestAdapter.adapt(data);
        final AuthorisePaymentResponse response = sendRequest(brand, HEALTH, "healthApplyService", "HEALTH-APPLY", "payment/authorise", data, request, AuthorisePaymentResponse.class);
        return ResponseAdapter.adapt(response);
    }

}
