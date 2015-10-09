package com.ctm.services.health;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.PremiumRange;
import com.ctm.model.settings.Brand;
import com.ctm.providers.health.healthquote.model.RequestAdapter;
import com.ctm.providers.health.healthquote.model.SummaryResponseAdapter;
import com.ctm.providers.health.healthquote.model.request.HealthQuoteRequest;
import com.ctm.providers.health.healthquote.model.response.HealthSummaryResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.Endpoint;
import com.ctm.utils.ObjectMapperUtil;

import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

public class HealthQuoteSummaryService extends CommonQuoteService<HealthQuote, HealthQuoteRequest, HealthSummaryResponse> {

    public HealthQuoteSummaryService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    public PremiumRange getSummary(Brand brand, HealthRequest data) throws DaoException, IOException, ServiceConfigurationException {
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data);
        final HealthSummaryResponse healthResponse = sendRequest(brand, HEALTH, "healthQuoteServiceBER", Endpoint.SUMMARY, data, quoteRequest, HealthSummaryResponse.class);
        return SummaryResponseAdapter.adapt(data, healthResponse);

    }

}
