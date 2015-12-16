package com.ctm.web.health.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.model.form.HealthRegisterPaymentRequest;
import com.ctm.web.health.model.results.HealthRegisterPaymentResult;
import com.ctm.web.health.payment.register.model.RequestAdapter;
import com.ctm.web.health.payment.register.model.ResponseAdapter;
import com.ctm.web.health.payment.register.model.request.RegisterPaymentRequest;
import com.ctm.web.health.payment.register.model.response.RegisterPaymentResponse;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthRegisterPaymentService extends CommonRequestService<RegisterPaymentRequest, RegisterPaymentResponse> {

    public HealthRegisterPaymentService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
        connection = new SimpleConnection();
    }

    public HealthRegisterPaymentResult register(Brand brand, HealthRegisterPaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final RegisterPaymentRequest request = RequestAdapter.adapt(data);
        final RegisterPaymentResponse response = sendRequest(brand, HEALTH, "healthApplyService", Endpoint.PAYMENT_REGISTER, data, request, RegisterPaymentResponse.class);
        return ResponseAdapter.adapt(response);
    }

}
