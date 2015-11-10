package com.ctm.web.health.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.HealthResult;
import com.ctm.web.health.quote.model.RequestAdapter;
import com.ctm.web.health.quote.model.ResponseAdapter;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.response.HealthResponse;
import org.apache.commons.lang3.tuple.Pair;

import java.io.IOException;
import java.util.List;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthQuoteService extends CommonQuoteService<HealthQuote, HealthQuoteRequest, HealthResponse> {

    public HealthQuoteService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    public Pair<Boolean, List<HealthResult>> getQuotes(Brand brand, HealthRequest data, Content alternatePricingContent) throws DaoException, IOException, ServiceConfigurationException {
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data, alternatePricingContent);
        final HealthResponse healthResponse = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.QUOTE, data, quoteRequest, HealthResponse.class);
        return ResponseAdapter.adapt(data, healthResponse, alternatePricingContent);
    }

}

