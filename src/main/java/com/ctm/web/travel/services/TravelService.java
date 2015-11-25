package com.ctm.web.travel.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.providers.model.Request;
import com.ctm.web.core.results.ResultPropertiesBuilder;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.Endpoint;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.ctm.web.travel.exceptions.TravelServiceException;
import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.quote.model.RequestAdapter;
import com.ctm.web.travel.quote.model.ResponseAdapter;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import com.ctm.web.travel.quote.model.response.TravelResponse;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.logging.XMLOutputWriter.REQ_OUT;

public class TravelService extends CommonQuoteService<TravelQuote, TravelQuoteRequest, TravelResponse> {

    private static final Logger LOGGER = LoggerFactory.getLogger(TravelService.class);

    public TravelService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, TravelRequest data) throws Exception {

        // Get quote from Form Request
        final TravelQuote quote = data.getQuote();

        setFilter(quote.getFilter());

        // Convert post data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);

        // Prepare objectmapper to map java model to JSON
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        objectMapper.registerModule(new JavaTimeModule());

        // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
        final List<TravelResult> travelResults = ResponseAdapter.adapt(travelQuoteRequest, travelResponse);

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (TravelResult result : travelResults) {
            if (AvailableType.Y.equals(result.getAvailable())) {

                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(
                        data.getTransactionId(), result.getProductId());
                builder.addResult("quoteUrl", result.getQuoteUrl());
                resultProperties.addAll(builder.getResultProperties());

            }
        }     

        ResultsService.saveResultsProperties(resultProperties);

        return travelResults;

    }
}
