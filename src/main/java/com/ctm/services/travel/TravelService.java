package com.ctm.services.travel;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.TravelServiceException;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.settings.Brand;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.travel.travelquote.model.RequestAdapter;
import com.ctm.providers.travel.travelquote.model.ResponseAdapter;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;
import com.ctm.services.CommonQuoteService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.ResultsService;
import com.ctm.xml.XMLOutputWriter;
import com.disc_au.web.go.Data;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.xml.XMLOutputWriter.REQ_OUT;

public class TravelService extends CommonQuoteService<TravelQuote> {

	private static final Logger logger = Logger.getLogger(TravelService.class.getName());
	private String vertical;
	private Data data;

    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param verticalCode
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, String verticalCode, com.ctm.model.travel.form.TravelRequest data) throws TravelServiceException{

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
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceProperties.getServiceUrl()+"/quote");
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
            logger.error("Error parsing or connecting to travel-quote", e);
        }

        return null;

    }



	public boolean isValid() {
		return valid;
	}

	public Data getGetData() {
		return data;
	}
}
