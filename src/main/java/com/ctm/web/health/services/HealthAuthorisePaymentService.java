package com.ctm.web.health.services;


import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.model.form.HealthAuthorisePaymentRequest;
import com.ctm.web.health.model.results.HealthPaymentAuthoriseResult;
import com.ctm.web.health.payment.authorise.model.ResponseAdapter;
import com.ctm.web.health.payment.authorise.model.request.AuthorisePaymentRequest;
import com.ctm.web.health.payment.authorise.model.response.AuthorisePaymentResponse;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthAuthorisePaymentService extends CommonRequestService {

    public HealthAuthorisePaymentService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper(),
                new ServiceConfigurationService(), EnvironmentService.getEnvironmentFromSpring());
    }

    public HealthPaymentAuthoriseResult authorise(Brand brand, HealthAuthorisePaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final AuthorisePaymentRequest request = com.ctm.web.health.payment.authorise.model.RequestAdapter.adapt(data);
        final AuthorisePaymentResponse response = sendRequest(brand, HEALTH, "healthApplyService", Endpoint.PAYMENT_AUTHORISE , data, request, AuthorisePaymentResponse.class);
        return ResponseAdapter.adapt(response);
    }

}
