package com.ctm.services.health;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.logging.XMLOutputWriter;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.content.Content;
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
import com.ctm.services.CommonQuoteService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.List;

import static com.ctm.logging.XMLOutputWriter.REQ_OUT;
import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

public class HealthQuoteService extends CommonQuoteService<HealthQuote> {

    private static final Logger logger = Logger.getLogger(HealthQuoteService.class);

    public Pair<Boolean, List<HealthResult>> getQuotes(Brand brand, HealthRequest data, Content alternatePricingContent) {

        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data, alternatePricingContent);
        request.setPayload(quoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("healthQuoteServiceBER", brand, HEALTH.getCode(), data);

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HEALTH-QUOTE" , serviceProperties.getDebugPath());
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceProperties.getServiceUrl() + "/quote");
            HealthResponse healthResponse = objectMapper.readValue(response, HealthResponse.class);

            // Log response
            writer.lastWriteXmlToFile(response);

            Pair<Boolean, List<HealthResult>> results = ResponseAdapter.adapt(data, healthResponse, alternatePricingContent);

            return results;

        }catch(IOException e){
            logger.error("Error parsing or connecting to car-quote", e);
        }

        return null;
    }

    public PremiumRange getSummary(Brand brand, HealthRequest data) {

        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data, null);
        request.setPayload(quoteRequest);

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties("healthQuoteServiceBER", brand, HEALTH.getCode(), data);

        try{

            String jsonRequest = objectMapper.writeValueAsString(request);

            // Log Request
            XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+"_HEALTH-QUOTE" , serviceProperties.getDebugPath());
            writer.writeXmlToFile(jsonRequest , REQ_OUT);

            SimpleConnection connection = new SimpleConnection();
            connection.setRequestMethod("POST");
            connection.setConnectTimeout(serviceProperties.getTimeout());
            connection.setReadTimeout(serviceProperties.getTimeout());
            connection.setContentType("application/json");
            connection.setPostBody(jsonRequest);

            String response = connection.get(serviceProperties.getServiceUrl() + "/summary");
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
