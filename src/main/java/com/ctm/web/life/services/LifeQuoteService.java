package com.ctm.web.life.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.life.form.model.LifeQuoteWebRequest;
import com.ctm.web.life.form.response.model.LifeResultsWebResponse;
import com.ctm.web.life.model.LifeQuoteResponse;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceRequestAdapter;
import com.ctm.web.life.quote.adapter.LifeQuoteServiceResponseAdapter;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.LIFE;

@Component
public class LifeQuoteService extends CommonRequestService {

    @Autowired
    private LifeQuoteServiceRequestAdapter requestAdapter;

    @Autowired
    private LifeQuoteServiceResponseAdapter responseAdapter;

    @Autowired
    public LifeQuoteService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper, ServiceConfigurationService serviceConfigurationService) {
        super(providerFilterDAO, objectMapper, serviceConfigurationService, EnvironmentService.getEnvironmentFromSpring());
    }

    public LifeResultsWebResponse getQuotes(LifeQuoteWebRequest request, Brand brand) throws DaoException, IOException, ServiceConfigurationException {
        final LifeQuoteResponse response = sendRequest(brand, LIFE, "quoteServiceBER", Endpoint.QUOTE, request,
                requestAdapter.adapt(request), LifeQuoteResponse.class);
        return responseAdapter.adapt(response, request);
    }
}
