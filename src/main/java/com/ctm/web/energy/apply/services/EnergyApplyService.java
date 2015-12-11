package com.ctm.web.energy.apply.services;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceRequestAdapter;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceResponseAdapter;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class EnergyApplyService  { //extends CommonRequestService<EnergyApplicationDetails,EnergyApplicationResponse> {

    @Autowired
    public EnergyApplyService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        //super(providerFilterDAO, objectMapper);
    }


    public EnergyApplyWebResponseModel apply(EnergyApplyPostRequestPayload model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
        EnergyApplyServiceResponseAdapter responseAdapter= new EnergyApplyServiceResponseAdapter();
        EnergyApplyServiceRequestAdapter requestAdapter = new EnergyApplyServiceRequestAdapter();
        final EnergyApplicationDetails energyApplicationDetails = requestAdapter.adapt(model);
//        EnergyApplicationResponse energyApplicationResponseModel = sendRequest(brand, ENERGY, "applyServiceBER", Endpoint.APPLY, model, energyApplicationDetails,
//                EnergyApplicationResponse.class);
//        return responseAdapter.adapt(energyApplicationResponseModel);
        return null;
	}
}
