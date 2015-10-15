package com.ctm.services.health;


import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthAuthorisePaymentRequest;
import com.ctm.model.health.results.HealthPaymentAuthoriseResult;
import com.ctm.model.settings.Brand;
import com.ctm.providers.health.healthpayment.authorise.model.ResponseAdapter;
import com.ctm.providers.health.healthpayment.authorise.model.request.AuthorisePaymentRequest;
import com.ctm.providers.health.healthpayment.authorise.model.response.AuthorisePaymentResponse;
import com.ctm.services.CommonRequestService;

import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

public class HealthAuthorisePaymentService extends CommonRequestService<AuthorisePaymentRequest, AuthorisePaymentResponse> {

    public HealthPaymentAuthoriseResult authorise(Brand brand, HealthAuthorisePaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final AuthorisePaymentRequest request = com.ctm.providers.health.healthpayment.authorise.model.RequestAdapter.adapt(data);
        final AuthorisePaymentResponse response = sendRequest(brand, HEALTH, "healthApplyService", "HEALTH-APPLY", "payment/authorise", data, request, AuthorisePaymentResponse.class);
        return ResponseAdapter.adapt(response);
    }

}
