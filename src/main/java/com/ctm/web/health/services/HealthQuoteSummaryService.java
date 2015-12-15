package com.ctm.web.health.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.results.PremiumRange;
import com.ctm.web.health.quote.model.RequestAdapter;
import com.ctm.web.health.quote.model.SummaryResponseAdapter;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.response.HealthSummaryResponse;

import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

public class HealthQuoteSummaryService extends CommonQuoteService<HealthQuote, HealthQuoteRequest, HealthSummaryResponse> {

    public HealthQuoteSummaryService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper(), new SimpleConnection());
    }

    public PremiumRange getSummary(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data);
        final HealthSummaryResponse healthResponse = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.SUMMARY, data, quoteRequest, HealthSummaryResponse.class);
        return SummaryResponseAdapter.adapt(data, healthResponse);

    }

}
