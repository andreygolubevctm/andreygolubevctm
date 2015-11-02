package com.ctm.web.travel.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.logging.XMLOutputWriter;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.providers.Request;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.core.services.CommonQuoteService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.homecontents.providers.request.ResultPropertiesBuilder;
import com.ctm.web.travel.exceptions.TravelServiceException;
import com.ctm.web.travel.model.form.TravelQuote;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.quote.model.RequestAdapter;
import com.ctm.web.travel.quote.model.ResponseAdapter;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import com.ctm.web.travel.quote.model.response.TravelResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;
import static com.ctm.web.core.logging.XMLOutputWriter.REQ_OUT;

public class TravelService extends CommonQuoteService<TravelQuote> {

	private static final Logger LOGGER = LoggerFactory.getLogger(TravelService.class);
    private SimpleConnection connection;

    public TravelService(ServiceConfiguration serviceConfig, SimpleConnection connection) {
        super(serviceConfig);
        this.connection = connection;
    }
    public TravelService() {
        super();
    }

    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param verticalCode
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, String verticalCode, com.ctm.web.travel.model.form.TravelRequest data) throws TravelServiceException{

        // Get quote from Form Request
        final TravelQuote quote = data.getQuote();

        // Generate request object for Travel-quote aggregation service
        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());

        // Check if Provider Key provided and use as filter if available
        // It is acceptable to throw exceptions here as provider key is checked
        // when page loaded so technically should not reach here otherwise.
        String providerKey = quote.getFilter().getProviderKey();
        if(providerKey != null) {
            ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
            try {
                String providerCode = providerFilterDAO.getProviderDetails(providerKey);
                quote.getFilter().setSingleProvider(providerCode);
            } catch(DaoException e) {
                throw new TravelServiceException("Provider Key error", e);
            }
        // Provider Key is mandatory in NXS
        } else if(EnvironmentService.getEnvironmentAsString().equalsIgnoreCase("nxs")) {
            throw new TravelServiceException("Provider Key required in '" + EnvironmentService.getEnvironmentAsString() + "' environment");
        }

        // Convert post data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(travelQuoteRequest);

        // Prepare objectmapper to map java model to JSON
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        objectMapper.setDateFormat(df);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("travelQuoteService", brand, verticalCode, data);

        // Call travel-quote
        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_TRAVEL-QUOTE" , serviceProperties.getDebugPath());
            writer.writeXmlToFile(jsonRequest, REQ_OUT);

            if(connection == null) {
                connection = new SimpleConnection();
            }
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);
            connection.setHasCorrelationId(true);

            String response = connection.get(serviceProperties.getServiceUrl() + "/quote");
            TravelResponse travelResponse = objectMapper.readValue(response, TravelResponse.class);

                // Log response
                writer.lastWriteXmlToFile(response);

                // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
                final List<TravelResult> travelResults = ResponseAdapter.adapt(travelQuoteRequest, travelResponse);

                List<ResultProperty> resultProperties = new ArrayList<>();
                for (TravelResult result : travelResults) {
                    if (AvailableType.Y.equals(result.getAvailable())) {

                        ResultPropertiesBuilder builder = new ResultPropertiesBuilder(request.getTransactionId(), result.getProductId());
                        builder.addResult("quoteUrl", result.getQuoteUrl());
                        resultProperties.addAll(builder.getResultProperties());

                    }
                }

                ResultsService.saveResultsProperties(resultProperties);

            return travelResults;

        }catch(IOException e){
            LOGGER.error("Error parsing or connecting to travel-quote {},{},{}", kv("brand", brand), kv("verticalCode", verticalCode),
                kv("travelRequest", data));
        }

        return new ArrayList<>();

    }
}
