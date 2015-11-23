package com.ctm.web.energy.services;

import com.ctm.energy.quote.request.model.EnergyQuoteRequest;
import com.ctm.energy.quote.response.model.EnergyResultsResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceRequestAdapter;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Service
public class EnergyResultsService extends EnergyBaseService {

    @Context
    private HttpServletRequest httpServletRequest;


    public EnergyResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public EnergyResultsWebResponse getResults(EnergyResultsWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
      validate( httpServletRequest,  model);
           if(isValid()) {
               EnergyQuoteServiceRequestAdapter mapper= new EnergyQuoteServiceRequestAdapter();
               EnergyQuoteServiceResponseAdapter  energyQuoteServiceResponseAdapter= new EnergyQuoteServiceResponseAdapter();
               final EnergyQuoteRequest energyQuoteRequest = mapper.adapt(model);
               final EnergyResultsResponse energyResultsModel = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.QUOTE, model, energyQuoteRequest, EnergyResultsResponse.class);
               return energyQuoteServiceResponseAdapter.adapt(energyResultsModel);
           }
        return null;

	}
}
