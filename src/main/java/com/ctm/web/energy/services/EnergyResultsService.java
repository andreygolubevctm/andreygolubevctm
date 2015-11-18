package com.ctm.web.energy.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.quote.response.model.EnergyResultsResponse;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceRequestMapper;
import com.ctm.web.energy.quote.model.EnergyQuoteRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Service
public class EnergyResultsService extends EnergyBaseService {

    @Context
    private HttpServletRequest httpServletRequest;

    @Autowired
    private SimpleConnection connection;

    public EnergyResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public ResultsWrapper getResults(EnergyResultsWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
      validate( httpServletRequest,  model);
           if(isValid()) {
               EnergyQuoteServiceRequestMapper mapper = Mappers.getMapper(EnergyQuoteServiceRequestMapper.class);
               final EnergyQuoteRequest energyQuoteRequest = mapper.adapt(model);
               final EnergyResultsResponse energyResultsModel = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.QUOTE, model, energyQuoteRequest, EnergyResultsResponse.class);
               return new ResultsWrapper(energyResultsModel);
           }
        return null;

	}
}
