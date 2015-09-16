package com.ctm.services;

import com.ctm.connectivity.SimpleConnection;
import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.*;
import com.ctm.logging.XMLOutputWriter;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.formData.Request;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.Vertical;
import com.ctm.utils.ObjectMapperUtil;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Optional;

import static com.ctm.logging.XMLOutputWriter.REQ_OUT;
import static com.ctm.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

public abstract class CommonQuoteService<QUOTE, PAYLOAD, RESPONSE> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonQuoteService.class);

    public static final String SERVICE_URL = "serviceUrl";
    public static final String TIMEOUT_MILLIS = "timeoutMillis";
    public static final String DEBUG_PATH = "debugPath";

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

    public QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Request<QUOTE> request) {
        return getQuoteServiceProperties(service, brand, verticalCode, Optional.ofNullable(request.getEnvironmentOverride()));
    }

    protected void setFilter(com.ctm.model.common.ProviderFilter providerFilter) throws Exception {
        if(!providerFilter.getProviderKey().isEmpty()) {
            // Check if Provider Key provided and use as filter if available
            // It is acceptable to throw exceptions here as provider key is checked
            // when page loaded so technically should not reach here otherwise.
            ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
            String providerCode = providerFilterDAO.getProviderDetails(providerFilter.getProviderKey());
            if (StringUtils.isBlank(providerCode)) {
                throw new RouterException("Invalid providerKey");
            } else {
                providerFilter.setSingleProvider(providerCode);
            }
            // Provider Key is mandatory in NXS
        } else if (!providerFilter.getAuthToken().isEmpty()) {
            // Check if AuthToken provided and use as filter if available
            // It is acceptable to throw exceptions here as provider key is checked
            // when page loaded so technically should not reach here otherwise.
            ProviderFilterDao providerFilterDAO = new ProviderFilterDao();
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

    protected RESPONSE sendRequest(Brand brand, Vertical.VerticalType vertical, String serviceName, String logTarget, Request data, PAYLOAD payload, Class<RESPONSE> responseClass) throws IOException {
        com.ctm.providers.Request request = new com.ctm.providers.Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());

        request.setPayload(payload);

        // Prepare objectmapper to map java model to JSON
        ObjectMapper objectMapper = ObjectMapperUtil.getObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        objectMapper.setDateFormat(df);

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties(serviceName, brand, vertical.getCode(), data);

        String jsonRequest = objectMapper.writeValueAsString(request);

        // Log Request
        XMLOutputWriter writer = new XMLOutputWriter(data.getTransactionId()+logTarget , serviceProperties.getDebugPath());
        writer.writeXmlToFile(jsonRequest , REQ_OUT);

        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("POST");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setContentType("application/json");
        connection.setPostBody(jsonRequest);

        String response = connection.get(serviceProperties.getServiceUrl() + "/quote");
        if (response == null) {
            throw new RouterException("Connection failed");
        }
        // Log response
        writer.lastWriteXmlToFile(response);
        return objectMapper.readValue(response, objectMapper.constructType(responseClass));
    }

    public QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Optional<String> environmentOverride) {
        // Get URL of home-quote service
        final QuoteServiceProperties properties = new QuoteServiceProperties();
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode).getId(), brand.getId());
            properties.setServiceUrl(serviceConfig.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
            properties.setDebugPath(serviceConfig.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
            String timeoutValue = serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
            if (timeoutValue != null) {
                properties.setTimeout(Integer.parseInt(timeoutValue));
            }
        }catch (DaoException | ServiceConfigurationException e ){
            throw new ServiceException("QuoteServiceProperties config error", e);
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

}
