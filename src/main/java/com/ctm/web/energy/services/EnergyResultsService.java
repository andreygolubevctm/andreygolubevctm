package com.ctm.web.energy.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.model.EnergyResultsModel;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceRequestAdapter;
import com.ctm.web.energy.quote.model.EnergyQuoteRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.ENERGY;

@Service
public class EnergyResultsService extends EnergyBaseService {

    @Context
    private HttpServletRequest httpServletRequest;

    @Autowired
    private SimpleConnection connection;

    @Autowired
    private EnergyQuoteServiceRequestAdapter adpater;

	public EnergyResultsService(){

	}


	public ResultsWrapper getResults(EnergyResultsWebRequest model, Brand brand) throws IOException {
        EnergyResultsModel energyResultsModel =  validate( httpServletRequest,  model);
           if(isValid()) {
               final EnergyQuoteRequest energyQuoteRequest = adpater.adapt(model);
               ObjectMapper objectMapper = new ObjectMapper();
               objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

               // Get URL of car-quote service
               QuoteServiceProperties serviceProperties = getQuoteServiceProperties("energyQuoteServiceBER", brand, ENERGY.getCode(), model);

               String jsonRequest = objectMapper.writeValueAsString(energyQuoteRequest);

               connection.setRequestMethod("POST");
               connection.setConnectTimeout(serviceProperties.getTimeout());
               connection.setReadTimeout(serviceProperties.getTimeout());
               connection.setContentType("application/json");
               connection.setPostBody(jsonRequest);

               String response = connection.get(serviceProperties.getServiceUrl() + "/quote");
               energyResultsModel = objectMapper.readValue(response, EnergyResultsModel.class);
           }
        return new ResultsWrapper(energyResultsModel);

	}
}
