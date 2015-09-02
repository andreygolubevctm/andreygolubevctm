package com.ctm.services.health;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.model.health.form.HealthQuote;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.health.results.HealthResult;
import com.ctm.model.health.results.PremiumRange;
import com.ctm.model.settings.Brand;
import com.ctm.providers.Request;
import com.ctm.providers.health.healthquote.model.RequestAdapter;
import com.ctm.providers.health.healthquote.model.ResponseAdapter;
import com.ctm.providers.health.healthquote.model.SummaryResponseAdapter;
import com.ctm.providers.health.healthquote.model.request.HealthQuoteRequest;
import com.ctm.providers.health.healthquote.model.response.HealthResponse;
import com.ctm.providers.health.healthquote.model.response.HealthSummaryResponse;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.ctm.xml.XMLOutputWriter;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.List;

import static com.ctm.xml.XMLOutputWriter.REQ_OUT;

public class HealthQuoteService {

    private static final Logger logger = Logger.getLogger(HealthQuoteService.class);

    public static final String SERVICE_URL = "serviceUrl";
    public static final String TIMEOUT_MILLIS = "timeoutMillis";
    public static final String DEBUG_PATH = "debugPath";
    private boolean valid = false;

    public List<SchemaValidationError> validateRequest(HealthRequest data, String vertical) {
        List<SchemaValidationError> errors = FormValidation.validate(data.getQuote(), vertical);
        valid = errors.isEmpty();
        return errors;
    }

    public List<HealthResult> getQuotes(Brand brand, HealthRequest data) {

        HealthQuote quote = data.getQuote();

//        // Fix the commencement date if prior to the current date
//        if (quote.getOptions() != null) {
//            String sanitisedCommencementDate = quote.getOptions().getCommencementDate();
//            // Fix the commencement date if prior to the current date
//            if (!CommencementDateValidation.isValid(quote.getOptions().getCommencementDate(), "dd/MM/yyyy")) {
//                try {
//                    sanitisedCommencementDate = CommencementDateValidation.getToday("dd/MM/yyyy");
//                } catch (Exception e) {
//                    throw new RouterException(e);
//                }
//            }
//
//            if (!StringUtils.equals(sanitisedCommencementDate, quote.getOptions().getCommencementDate())) {
//                quote.getOptions().setCommencementDate(sanitisedCommencementDate);
//            }
//        }


        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data);
        request.setPayload(quoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        // Get URL of car-quote service
        String serviceUrl = "http://localhost:9083";
        String debugPath = "health/debug";
        int timeout = 30000;
//        try {
//            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("healthQuoteServiceBER", brand.getVerticalByCode(Vertical.VerticalType.HEALTH.getCode()).getId(), brand.getId());
//            serviceUrl = serviceConfig.getPropertyValueByKey(SERVICE_URL, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
//            debugPath = serviceConfig.getPropertyValueByKey(DEBUG_PATH, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
//            timeout = Integer.parseInt(serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE));
//        }catch (DaoException | ServiceConfigurationException e ){
//            throw new ServiceException("HealthQuote config error", e);
//        }

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HEALTH-QUOTE" , debugPath);
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(timeout);
            connection.setReadTimeout(timeout);
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceUrl + "/quote");
            HealthResponse healthResponse = objectMapper.readValue(response, HealthResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            List<HealthResult> results = ResponseAdapter.adapt(data, healthResponse);

//            saveResults(data, carResults);

            return results;

        }catch(IOException e){
            logger.error("Error parsing or connecting to car-quote", e);
        }

        return null;
    }

    public PremiumRange getSummary(Brand brand, HealthRequest data) {

        HealthQuote quote = data.getQuote();

//        // Fix the commencement date if prior to the current date
//        if (quote.getOptions() != null) {
//            String sanitisedCommencementDate = quote.getOptions().getCommencementDate();
//            // Fix the commencement date if prior to the current date
//            if (!CommencementDateValidation.isValid(quote.getOptions().getCommencementDate(), "dd/MM/yyyy")) {
//                try {
//                    sanitisedCommencementDate = CommencementDateValidation.getToday("dd/MM/yyyy");
//                } catch (Exception e) {
//                    throw new RouterException(e);
//                }
//            }
//
//            if (!StringUtils.equals(sanitisedCommencementDate, quote.getOptions().getCommencementDate())) {
//                quote.getOptions().setCommencementDate(sanitisedCommencementDate);
//            }
//        }


        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data);
        request.setPayload(quoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        // Get URL of car-quote service
        String serviceUrl = "http://localhost:9083";
        String debugPath = "health/debug";
        int timeout = 30000;
//        try {
//            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("healthQuoteServiceBER", brand.getVerticalByCode(Vertical.VerticalType.HEALTH.getCode()).getId(), brand.getId());
//            serviceUrl = serviceConfig.getPropertyValueByKey(SERVICE_URL, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
//            debugPath = serviceConfig.getPropertyValueByKey(DEBUG_PATH, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
//            timeout = Integer.parseInt(serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE));
//        }catch (DaoException | ServiceConfigurationException e ){
//            throw new ServiceException("HealthQuote config error", e);
//        }

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HEALTH-QUOTE" , debugPath);
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(timeout);
            connection.setReadTimeout(timeout);
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceUrl + "/summary");
            HealthSummaryResponse healthResponse = objectMapper.readValue(response, HealthSummaryResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            return SummaryResponseAdapter.adapt(data, healthResponse);

        }catch(IOException e){
            logger.error("Error parsing or connecting to car-quote", e);
        }

        return null;
    }

}
