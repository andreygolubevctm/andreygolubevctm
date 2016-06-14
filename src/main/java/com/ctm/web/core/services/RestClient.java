package com.ctm.web.core.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.cxf.common.i18n.UncheckedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class RestClient {

    private static final Logger LOGGER = LoggerFactory.getLogger(RestClient.class);

    private final ObjectMapper objectMapper;

    @Autowired
    public RestClient(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public <RESPONSE> RESPONSE sendPOSTRequest(QuoteServiceProperties serviceProperties,
                                               Endpoint endpoint,
                                               Class<RESPONSE> responseClass, Object requestObj)
            throws ServiceConfigurationException, DaoException, IOException {
        return sendPOSTRequest( serviceProperties,  endpoint.getValue(),
                responseClass,  requestObj);
    }

    public <RESPONSE> RESPONSE sendPOSTRequest(QuoteServiceProperties serviceProperties, String endpoint, Class<RESPONSE> responseClass, Object requestObj)
            throws IOException {

        String jsonRequest = objectMapper.writeValueAsString(requestObj);

        // Log Request
        LOGGER.info("Sending request {} ", kv("endpoint", endpoint));
        LOGGER.debug("Outbound message {}", kv("request", jsonRequest));

        String response = setupSimplePOSTConnection(serviceProperties, jsonRequest)
                .get(serviceProperties.getServiceUrl() + "/" + endpoint);
        if (response == null) {
            throw new RouterException("Connection failed");
        }

        // Log response
        LOGGER.info("Receiving response {} ", kv("endpoint", endpoint));
        LOGGER.debug("Inbound message {}", kv("response", response));

        return objectMapper.readValue(response, objectMapper.constructType(responseClass));
    }

    public <RESPONSE> RESPONSE sendGETRequest(QuoteServiceProperties serviceProperties, Endpoint endpoint, TypeReference<RESPONSE> typeReference, Map<String, String> params)
            throws  IOException {

        // Log Request
        LOGGER.info("Sending request {}", kv("endpoint", endpoint));

        String response = setupSimpleGETConnection(serviceProperties)
                .get(createGETUrl(serviceProperties, endpoint, params));
        if (response == null) {
            throw new RouterException("Connection failed");
        }

        // Log response
        LOGGER.info("Receiving response {}", kv("endpoint", endpoint));
        LOGGER.debug("Inbound message {}", kv("response", response));

        return objectMapper.readValue(response, typeReference);
    }

    protected String createGETUrl(QuoteServiceProperties serviceProperties, Endpoint endpoint, Map<String, String> params) {
        StringBuilder sb = new StringBuilder(serviceProperties.getServiceUrl());
        sb.append("/").append(endpoint.getValue());

        if (params != null && !params.isEmpty()) {
            sb.append(
            params.entrySet().stream()
                    .map(e -> e.getKey() + "=" + encodeParamValue(e.getValue()))
                    .collect(Collectors.joining("&", "?", "")));
        }
        return sb.toString();
    }

    protected String encodeParamValue(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new UncheckedException(e);
        }
    }

    protected SimpleConnection setupSimplePOSTConnection(QuoteServiceProperties serviceProperties, String jsonRequest) {
        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("POST");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setContentType("application/json");
        connection.setPostBody(jsonRequest);
        connection.setHasCorrelationId(true);
        return connection;
    }

    protected SimpleConnection setupSimpleGETConnection(QuoteServiceProperties serviceProperties) {
        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setHasCorrelationId(true);
        return connection;
    }

}
