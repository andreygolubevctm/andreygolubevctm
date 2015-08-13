package com.ctm.services.travel;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.TravelServiceException;
import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.settings.*;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.providers.Request;
import com.ctm.providers.ResultPropertiesBuilder;
import com.ctm.providers.travel.travelquote.model.RequestAdapter;
import com.ctm.providers.travel.travelquote.model.ResponseAdapter;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;
import com.ctm.services.*;
import com.ctm.xml.XMLOutputWriter;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.log4j.Logger;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;

import static com.ctm.xml.XMLOutputWriter.REQ_OUT;

public class TravelService {

	private static final Logger logger = Logger.getLogger(TravelService.class.getName());
	private boolean valid = false;
	private String vertical;
	private Data data;

	public List<SchemaValidationError> validateRequest(com.ctm.model.travel.form.TravelRequest travelRequest, String vertical) {
		List<SchemaValidationError> errors = FormValidation.validate(travelRequest.getQuote(), vertical);
		valid = errors.isEmpty();
		return errors;
	}

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

        // Convert posted data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(travelQuoteRequest);

        // Prepare objectmapper to map java model to JSON
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        objectMapper.setDateFormat(df);

        // Get URL of travel-quote service
        String serviceUrl = null;
        String debugPath = null;
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("travelQuoteService", brand.getVerticalByCode(verticalCode).getId(), brand.getId());
            serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
            debugPath = serviceConfig.getPropertyValueByKey("debugPath", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
        }catch (DaoException | ServiceConfigurationException e ){
            throw new TravelServiceException("TravelQuote config error", e);
        }

        EnvironmentService environmentService = new EnvironmentService();

        if(environmentService.getEnvironment() == EnvironmentService.Environment.LOCALHOST || environmentService.getEnvironment() == EnvironmentService.Environment.NXI){
            if(data.getEnvironmentOverride() != null && data.getEnvironmentOverride().equals("") == false) {
                serviceUrl = data.getEnvironmentOverride();
            }
        }

        // Call travel-quote
        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_TRAVEL-QUOTE" , debugPath);
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(32000);
            connection.setReadTimeout(32000);
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceUrl+"/quote");
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
