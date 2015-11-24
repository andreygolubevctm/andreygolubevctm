package com.ctm.web.energy.services;

import com.ctm.energy.quote.request.model.EnergyQuoteRequest;
import com.ctm.energy.quote.response.model.EnergyQuote;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;
import com.ctm.web.energy.model.EnergyQuoteResponse;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceRequestAdapter;
import com.ctm.web.energy.quote.adapter.EnergyQuoteServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import java.io.IOException;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.ENERGY;

@Service
public class EnergyResultsService extends CommonRequestService<EnergyQuoteRequest,EnergyQuoteResponse> {

    private static final String vertical = Vertical.VerticalType.ENERGY.getCode();

    @Context
    private HttpServletRequest httpServletRequest;
    private boolean valid;


    public EnergyResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }


    public EnergyResultsWebResponse getResults(EnergyResultsWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
      validate(model);
        if(valid) {
               EnergyQuoteServiceRequestAdapter mapper= new EnergyQuoteServiceRequestAdapter();
               EnergyQuoteServiceResponseAdapter  energyQuoteServiceResponseAdapter= new EnergyQuoteServiceResponseAdapter();
               final EnergyQuoteRequest energyQuoteRequest = mapper.adapt(model);
               Response<EnergyQuote> energyResultsModel = sendRequest(brand, ENERGY, "QuoteServiceBER", Endpoint.QUOTE, model, energyQuoteRequest,
                       EnergyQuoteResponse.class);
               return energyQuoteServiceResponseAdapter.adapt(energyResultsModel);
        }
        return null;

	}

    public List<SchemaValidationError> validate(EnergyResultsWebRequest utilitiesRequest) {
        List<SchemaValidationError> errors = FormValidation.validate(utilitiesRequest, vertical.toLowerCase(), false);
         valid = errors.isEmpty();
        return errors;
    }
}
