package com.ctm.web.energy.services;

import com.ctm.energy.provider.request.model.EnergyProviderRequest;
import com.ctm.energy.provider.response.model.EnergyProviders;
import com.ctm.energy.quote.request.model.EnergyQuoteRequest;
import com.ctm.energy.quote.response.model.EnergyQuote;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;
import com.ctm.web.energy.model.EnergyProviderResponse;
import com.ctm.web.energy.model.EnergyQuoteResponse;
import com.ctm.web.energy.provider.adapter.EnergyProviderServiceRequestAdapter;
import com.ctm.web.energy.provider.adapter.EnergyProviderServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.ENERGY;

@Component
public class EnergyProviderResultsService extends CommonRequestService<EnergyProviderRequest, EnergyProviderResponse>{

    @Autowired
    private EnergyProviderServiceRequestAdapter energyProviderServiceRequestAdapter;
    @Autowired
    private EnergyProviderServiceResponseAdapter energyProviderServiceResponseAdapter;

    @Autowired
    public EnergyProviderResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public EnergyProvidersWebResponse getResults(EnergyProviderWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
        final EnergyProviderRequest request = energyProviderServiceRequestAdapter.adapt(model);
        Response<EnergyProviders> energyResultsModel = sendRequest(brand, ENERGY, "quoteServiceBER", Endpoint.PROVIDER, model, request,
                EnergyProviderResponse.class);
        return energyProviderServiceResponseAdapter.adapt(energyResultsModel);
    }
}
