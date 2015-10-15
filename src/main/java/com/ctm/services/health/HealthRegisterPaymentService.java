package com.ctm.services.health;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthRegisterPaymentRequest;
import com.ctm.model.health.results.HealthRegisterPaymentResult;
import com.ctm.model.settings.Brand;
import com.ctm.providers.health.healthpayment.register.model.RequestAdapter;
import com.ctm.providers.health.healthpayment.register.model.ResponseAdapter;
import com.ctm.providers.health.healthpayment.register.model.request.RegisterPaymentRequest;
import com.ctm.providers.health.healthpayment.register.model.response.RegisterPaymentResponse;
import com.ctm.services.CommonRequestService;

import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

public class HealthRegisterPaymentService extends CommonRequestService<RegisterPaymentRequest, RegisterPaymentResponse> {

    public HealthRegisterPaymentResult register(Brand brand, HealthRegisterPaymentRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final RegisterPaymentRequest request = RequestAdapter.adapt(data);
        final RegisterPaymentResponse response = sendRequest(brand, HEALTH, "healthApplyService", "HEALTH-APPLY", "payment/register", data, request, RegisterPaymentResponse.class);
        return ResponseAdapter.adapt(response);
    }

}
