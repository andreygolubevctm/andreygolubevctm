package com.ctm.web.energy.services;

import com.ctm.energy.quote.request.model.EnergyQuoteRequest;
import com.ctm.energy.quote.response.model.EnergyQuote;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;
import com.ctm.web.energy.model.EnergyQuoteResponse;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceRequestAdapter;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.ENERGY;

@Component
public class EnergyResultsService extends CommonRequestService {

    @Autowired
    public EnergyResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper, ServiceConfigurationService serviceConfigurationService) {
        super(providerFilterDAO, objectMapper, serviceConfigurationService, EnvironmentService.getEnvironmentFromSpring());
    }


    public EnergyResultsWebResponse getResults(EnergyResultsWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
        EnergyQuoteServiceRequestAdapter mapper= new EnergyQuoteServiceRequestAdapter();
        EnergyQuoteServiceResponseAdapter  energyQuoteServiceResponseAdapter= new EnergyQuoteServiceResponseAdapter();
        final EnergyQuoteRequest energyQuoteRequest = mapper.adapt(model);
        Response<EnergyQuote> energyResultsModel = sendRequest(brand, ENERGY, "quoteServiceBER", Endpoint.QUOTE, model, energyQuoteRequest,
                       EnergyQuoteResponse.class);
        return energyQuoteServiceResponseAdapter.adapt(energyResultsModel);
	}
}
