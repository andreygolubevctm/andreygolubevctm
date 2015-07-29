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
import com.ctm.model.AvailableType;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.settings.*;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.providers.Request;
import com.ctm.providers.travel.travelquote.model.RequestAdapter;
import com.ctm.providers.travel.travelquote.model.ResponseAdapter;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;
import com.ctm.services.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.log4j.Logger;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

/**
 * TODO: once away from jsp create a router for this
 * @author adiente
 *
 */
public class TravelService {

	private static final Logger logger = Logger.getLogger(TravelService.class.getName());
	private boolean valid = false;
	private String vertical;
	private Data data;




	public List<SchemaValidationError> validateRequest(com.ctm.model.travel.form.TravelRequest travelRequest, String vertical) {
		List<SchemaValidationError> errors = FormValidation.validate(travelRequest, vertical);
		valid = errors.isEmpty();
		return errors;
	}

	private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
		String response;
		FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "TravelService.java:validateRequest");
		response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
		return response;
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
logger.info("ABOUT TO ADAPT FORM DATA TO TRAVEL-QUOTE REQUEST");
        // Convert posted data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(travelQuoteRequest);
        logger.info("ABOUT TO PREPARE OBJECT MAPPER");
        // Prepare objectmapper to map java model to JSON
        // TODO use response utils
        ObjectMapper objectMapper = new ObjectMapper();
        //objectMapper.configure(SerializationConfig.Feature.WRITE_DATES_AS_TIMESTAMPS, false);
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        objectMapper.setDateFormat(df);
        // Get URL of travel-quote service
        String serviceUrl = null;
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("travelQuoteService", brand.getVerticalByCode(verticalCode).getId(), brand.getId());
            serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
        }catch (DaoException | ServiceConfigurationException e ){
            throw new TravelServiceException("TravelQuote config error", e);
        }
        logger.info("ABOUT TO CALL TRAVEL QUOTE");

        try{
            String jsonRequest = objectMapper.writeValueAsString(request);
            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(30000);
            connection.setReadTimeout(30000);
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            //logger.debug("Message to "+serviceUrl+": "+jsonRequest);
            String response = connection.get(serviceUrl+"/quote");
            //logger.debug("Message from "+serviceUrl+": "+response);
            TravelResponse travelResponse = objectMapper.readValue(response, TravelResponse.class);


        logger.info("ABOUT TO ADAPT RESPONSE"+travelResponse.getTransactionId());
        // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
        final List<TravelResult> travelResults = ResponseAdapter.adapt(travelQuoteRequest, travelResponse);

        // Write to ResultsObj properties for EDM purposes
        LocalDate validUntil = new LocalDate().plusDays(30);

        DateTimeFormatter emailDateFormat = DateTimeFormat.forPattern("dd MMMMM yyyy");
        DateTimeFormatter normalFormat = DateTimeFormat.forPattern("yyyy-MM-dd");

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (TravelResult result : travelResults) {
            if (AvailableType.Y.equals(result.getAvailable())) {

/*
                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(request.getTransactionId(),
                        result.getProductId());

                builder.addResult("validateDate/display", emailDateFormat.print(validUntil))
                        .addResult("validateDate/normal", normalFormat.print(validUntil))
                        .addResult("productId", result.getProductId())
                        .addResult("productDes", result.getProviderProductName())
                        .addResult("excess/total", result.getExcess())
                        .addResult("headline/name", result.getProductName())
                        .addResult("quoteUrl", result.getQuoteUrl())
                        .addResult("telNo", result.getContact().getPhoneNumber())
                        .addResult("openingHours", result.getContact().getCallCentreHours())
                        .addResult("leadNo", result.getQuoteNumber())
                        .addResult("brandCode", result.getBrandCode());

                resultProperties.addAll(builder.getResultProperties());
                */
            }
        }

        ResultsService.saveResultsProperties(resultProperties);
            return travelResults;
        }catch(IOException e){
            logger.error("CONNECTION AND PARSING PROBLEM", e);
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
