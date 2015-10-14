package com.ctm.services.health;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.content.Content;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.HealthResult;
import com.ctm.model.settings.Brand;
import com.ctm.providers.health.healthquote.model.RequestAdapter;
import com.ctm.providers.health.healthquote.model.ResponseAdapter;
import com.ctm.providers.health.healthquote.model.request.HealthQuoteRequest;
import com.ctm.providers.health.healthquote.model.response.HealthResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.Endpoint;
import com.ctm.utils.ObjectMapperUtil;
import org.apache.commons.lang3.tuple.Pair;

import java.io.IOException;
import java.util.List;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

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

