package com.ctm.web.energy.services;

import com.ctm.energy.product.request.model.EnergyProductRequest;
import com.ctm.energy.product.response.model.EnergyProduct;
import com.ctm.energy.provider.request.model.EnergyProviderRequest;
import com.ctm.energy.provider.response.model.EnergyProviders;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.Response;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.energy.form.model.EnergyProductInfoWebRequest;
import com.ctm.web.energy.form.model.EnergyProviderWebRequest;
import com.ctm.web.energy.form.response.model.EnergyProductInfoWebResponse;
import com.ctm.web.energy.form.response.model.EnergyProvidersWebResponse;
import com.ctm.web.energy.model.EnergyProductResponse;
import com.ctm.web.energy.model.EnergyProviderResponse;
import com.ctm.web.energy.product.adapter.EnergyProductServiceRequestAdapter;
import com.ctm.web.energy.product.adapter.EnergyProductServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.ENERGY;

@Component
public class EnergyProductResultsService extends CommonRequestService<EnergyProductRequest, EnergyProductResponse> {

    @Autowired
    private EnergyProductServiceRequestAdapter energyProductServiceRequestAdapter;
    @Autowired
    private EnergyProductServiceResponseAdapter energyProductServiceResponseAdapter;

    @Autowired
    public EnergyProductResultsService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public EnergyProductInfoWebResponse getResults(EnergyProductInfoWebRequest model, Brand brand) throws IOException, DaoException, ServiceConfigurationException {
        final EnergyProductRequest request = energyProductServiceRequestAdapter.adapt(model);
        Response<EnergyProduct> energyResultsModel = sendRequest(brand, ENERGY, "quoteServiceBER", Endpoint.PRODUCT_INFO, model, request,
                EnergyProductResponse.class);
        return energyProductServiceResponseAdapter.adapt(energyResultsModel);
    }
}
