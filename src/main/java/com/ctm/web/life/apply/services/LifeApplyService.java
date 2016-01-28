package com.ctm.web.life.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.apply.model.response.SingleApplyResponse;
import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.interfaces.common.types.Status;
import com.ctm.web.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.energy.apply.services.EnergyApplyConfirmationService;
import com.ctm.web.life.apply.adapter.LifeApplyServiceRequestAdapter;
import com.ctm.web.life.apply.adapter.LifeApplyServiceResponseAdapter;
import com.ctm.web.life.apply.model.request.LifeApplyPostRequestPayload;
import com.ctm.web.life.apply.response.LifeApplyWebResponseModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Component
public class LifeApplyService extends CommonRequestService<EnergyApplicationDetails,SingleApplyResponse> {

    @Autowired
    private EnergyApplyConfirmationService energyApplyConfirmation;

    @Autowired
    public LifeApplyService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public LifeApplyWebResponseModel apply(LifeApplyPostRequestPayload model, Brand brand, HttpServletRequest request) throws IOException, DaoException, ServiceConfigurationException {
        LifeApplyServiceResponseAdapter responseAdapter= new LifeApplyServiceResponseAdapter();
        LifeApplyServiceRequestAdapter requestAdapter = new LifeApplyServiceRequestAdapter();
        final LifeApplicationDetails energyApplicationDetails = requestAdapter.adapt(model);

        String endpoint;
        if("ozicare".equals(model.getCompany())){
            endpoint = "ozicare/" + Endpoint.APPLY;
        } else {
            endpoint = "lifebroker/" + Endpoint.APPLY;
            className = SingleApplyResponse.class;
        }
        ApplyResponse applyResponse = sendApplyRequest(brand, Vertical.VerticalType.LIFE, "applyServiceBER", endpoint, model, energyApplicationDetails,
                SingleApplyResponse.class, requestAdapter.getProductId(model));
        if(Status.REGISTERED.equals(applyResponse.getResponseStatus())) {
            String confirmationKey = energyApplyConfirmation.createAndSaveConfirmation(request.getSession().getId(), model, applyResponse, requestAdapter);
            return responseAdapter.adapt(applyResponse)
                    .transactionId(model.getTransactionId())
                    .confirmationkey(confirmationKey).build();
        } else {
            throw new FailedToRegisterException(applyResponse, model.getTransactionId());
        }
	}

}
