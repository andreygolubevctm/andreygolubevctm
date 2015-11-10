package com.ctm.web.core.services;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.*;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.logging.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

public abstract class CommonQuoteService<QUOTE, PAYLOAD, RESPONSE> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteService.class);

    protected static final String SERVICE_URL = "serviceUrl";
    protected static final String TIMEOUT_MILLIS = "timeoutMillis";
    protected static final String DEBUG_PATH = "debugPath";

    protected static final DateTimeFormatter EMAIL_DATE_FORMAT = DateTimeFormat.forPattern("dd MMMMM yyyy");
    protected static final DateTimeFormatter NORMAL_FORMAT = DateTimeFormat.forPattern("yyyy-MM-dd");

    private final ProviderFilterDao providerFilterDAO;
    private final ObjectMapper objectMapper;

    public CommonQuoteService(final ProviderFilterDao providerFilterDAO, final ObjectMapper objectMapper) {
        this.providerFilterDAO = providerFilterDAO;
        this.objectMapper = objectMapper;
    }

    public boolean validateRequest(Request<QUOTE> data, String verticalCode) {
        // Validate request
        if (data == null) {
            LOGGER.error("Invalid request: data null");
            throw new RouterException("Data quote is missing");
        }
        if(data.getQuote() == null){
            LOGGER.error("Invalid request: data.quote null");
            throw new RouterException("Data quote is missing");
        }
        List<SchemaValidationError> errors = FormValidation.validate(data.getQuote(), verticalCode);
        if(errors.size() > 0){
            LOGGER.error("Invalid request: {}",errors);
            throw new RouterException("Invalid request"); // TODO pass validation errors to client
        }
        return true;
    }

    protected void setFilter(com.ctm.web.core.model.ProviderFilter providerFilter) throws Exception {
        if(StringUtils.isNotBlank(providerFilter.getProviderKey())) {
            // Check if Provider Key provided and use as filter if available
            // It is acceptable to throw exceptions here as provider key is checked
            // when page loaded so technically should not reach here otherwise.
            String providerCode = providerFilterDAO.getProviderDetails(providerFilter.getProviderKey());
            if (StringUtils.isBlank(providerCode)) {
                throw new RouterException("Invalid providerKey");
            } else {
                providerFilter.setSingleProvider(providerCode);
            }
            // Provider Key is mandatory in NXS
        } else if (StringUtils.isNotBlank(providerFilter.getAuthToken())) {
            // Check if AuthToken provided and use as filter if available
            // It is acceptable to throw exceptions here as provider key is checked
            // when page loaded so technically should not reach here otherwise.
            List<String> providerCode = providerFilterDAO.getProviderDetailsByAuthToken(providerFilter.getAuthToken());
            if (providerCode.isEmpty()) {
                throw new RouterException("Invalid Auth Token");
            } else {
                providerFilter.setProviders(providerCode);
            }
            // Provider Key is mandatory in NXS
        } else if(EnvironmentService.getEnvironmentAsString().equalsIgnoreCase("nxs")) {
            throw new RouterException("Provider Key required in '" + EnvironmentService.getEnvironmentAsString() + "' environment");
        }
    }

    protected RESPONSE sendRequest(Brand brand, Vertical.VerticalType vertical, String serviceName, Endpoint endpoint, Request<QUOTE> data, PAYLOAD payload, Class<RESPONSE> responseClass) throws IOException, DaoException, ServiceConfigurationException {
        com.ctm.web.core.providers.model.Request<PAYLOAD> request = new com.ctm.web.core.providers.model.Request<PAYLOAD>();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());

        request.setPayload(payload);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties(serviceName, brand, vertical.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        String jsonRequest = objectMapper.writeValueAsString(request);

        // Log Request
        LOGGER.info("Sending request {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Outbound message {} {} {}", kv("vertical", vertical), kv("endpoint", endpoint), kv("request", jsonRequest));

        SimpleConnection connection = getSimpleConnection(serviceProperties, jsonRequest);

        String response = connection.get(serviceProperties.getServiceUrl() + "/" +endpoint.getValue());
        if (response == null) {
            throw new RouterException("Connection failed");
        }
        // Log response
        LOGGER.info("Receiving response {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Inbound message {} {} {}", kv("vertical", vertical), kv("endpoint", endpoint), kv("response", response));

        return objectMapper.readValue(response, objectMapper.constructType(responseClass));
    }

    protected SimpleConnection getSimpleConnection(QuoteServiceProperties serviceProperties, String jsonRequest) {
        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("POST");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setContentType("application/json");
        connection.setPostBody(jsonRequest);
        connection.setHasCorrelationId(true);
        return connection;
    }

    protected QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Optional<String> environmentOverride) throws ServiceConfigurationException, DaoException {
        final QuoteServiceProperties properties = new QuoteServiceProperties();
        ServiceConfiguration serviceConfig = getServiceConfiguration(service, brand, verticalCode);
        properties.setServiceUrl(serviceConfig.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
        properties.setDebugPath(serviceConfig.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
        String timeoutValue = serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        if (timeoutValue != null) {
            properties.setTimeout(Integer.parseInt(timeoutValue));
        }

        environmentOverride.ifPresent(data -> {
            if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.LOCALHOST ||
                    EnvironmentService.getEnvironment() == EnvironmentService.Environment.NXI){
                if(StringUtils.isNotBlank(data)) {
                    properties.setServiceUrl(data);
                }
            }
        });

        return properties;

    }

    protected ServiceConfiguration getServiceConfiguration(String service, Brand brand, String verticalCode) throws DaoException, ServiceConfigurationException {
        return ServiceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode).getId(), brand.getId());
    }

}
