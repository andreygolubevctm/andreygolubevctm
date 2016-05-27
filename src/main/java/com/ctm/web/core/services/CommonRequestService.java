package com.ctm.web.core.services;

import com.ctm.apply.model.request.ApplyRequest;
import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.Vertical;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

@Component
public class CommonRequestService<PAYLOAD, RESPONSE> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonRequestService.class);

    protected static final String SERVICE_URL = "serviceUrl";
    protected static final String TIMEOUT_MILLIS = "timeoutMillis";
    protected static final String DEBUG_PATH = "debugPath";

    protected static final DateTimeFormatter EMAIL_DATE_FORMAT = DateTimeFormat.forPattern("dd MMMMM yyyy");
    protected static final DateTimeFormatter NORMAL_FORMAT = DateTimeFormat.forPattern("yyyy-MM-dd");

    private final ProviderFilterDao providerFilterDAO;
    private final RestClient restClient;
    private final ServiceConfigurationServiceBean serviceConfigurationService;
    private final EnvironmentService.Environment environment;
    private final ObjectMapper objectMapper;

    public CommonRequestService(final ProviderFilterDao providerFilterDAO,
                                final ObjectMapper objectMapper, EnvironmentService.Environment environment) {
        this.providerFilterDAO = providerFilterDAO;
        this.environment = environment;
        this.restClient = new RestClient(objectMapper);
        this.serviceConfigurationService = new ServiceConfigurationServiceBean();
        this.objectMapper = objectMapper;
    }

    public CommonRequestService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        this.providerFilterDAO = providerFilterDAO;
        this.restClient = new RestClient(objectMapper);
        this.environment = EnvironmentService.getEnvironmentFromSpring();
        this.serviceConfigurationService = new ServiceConfigurationServiceBean();
        this.objectMapper = objectMapper;
    }

    @Autowired
    public CommonRequestService(final ProviderFilterDao providerFilterDAO,
                                final RestClient restClient,
                                ServiceConfigurationServiceBean serviceConfigurationService,
                                @Qualifier("environmentBean") EnvironmentService.Environment environment, ObjectMapper objectMapper) {
        this.providerFilterDAO = providerFilterDAO;
        this.restClient = restClient;
        this.serviceConfigurationService = serviceConfigurationService;
        this.environment = environment;
        this.objectMapper = objectMapper;
    }

    public CommonRequestService(final ProviderFilterDao providerFilterDAO,
                                final ObjectMapper objectMapper,
                                ServiceConfigurationServiceBean serviceConfigurationService,
                                EnvironmentService.Environment environment) {
        this.providerFilterDAO = providerFilterDAO;
        this.restClient = new RestClient(objectMapper);
        this.serviceConfigurationService = serviceConfigurationService;
        this.environment = environment;
        this.objectMapper = objectMapper;
    }

    protected void setFilter(ProviderFilter providerFilter) throws Exception {
        if(providerFilter.getProviderKey() != null && !providerFilter.getProviderKey().isEmpty()) {
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
        } else if(providerFilter.getProviders() != null && !providerFilter.getProviders().isEmpty()) {
            // Check if Providers in list exist and throw exception if not.
            // No need to write anything to filter as already exists
            for (String code : providerFilter.getProviders()) {
                String providerCode = providerFilterDAO.getProviderDetails(providerFilter.getProviderKey());
                if (StringUtils.isBlank(providerCode)) {
                    throw new RouterException("Invalid providerKey in providers list");
                }
            }
        } else if(providerFilter.getAuthToken() != null && !providerFilter.getAuthToken().isEmpty()) {
            // Check if authToken exists and get let of related provider codes.
            // Then set that list in the providerFilter
            List<String> providers = ProviderService.getProvidersByAuthToken(providerFilter.getAuthToken());
            if(providers == null || providers.isEmpty()) {
                throw new RouterException("Invalid AuthToken");
            } else {
                providerFilter.setProviders(providers);
            }
            // Provider Key is mandatory in NXS
        } else if(environment.toString().equalsIgnoreCase("nxs")) {
            throw new RouterException("Provider Key required in '" + environment + "' environment");
        }
    }

    public RESPONSE sendRequest(Brand brand,
                                   Vertical.VerticalType vertical,
                                   String serviceName,
                                   Endpoint endpoint, Request data,
                                   PAYLOAD payload,
                                   Class<RESPONSE> responseClass) throws IOException, DaoException, ServiceConfigurationException {
        return sendRequestToService(brand, vertical, serviceName, endpoint, data, responseClass,  getQuoteRequest(brand, data, payload));
    }

    protected <RESPONSE> RESPONSE sendApplyRequest(Brand brand,
                                                            Vertical.VerticalType vertical,
                                                            String serviceName,
                                                            Endpoint endpoint, Request data,
                                                            PAYLOAD payload,
                                                            Class<RESPONSE> responseClass, String productId) throws RouterException {
        try {
            return restClient.sendPOSTRequest(getQuoteServiceProperties(serviceName,
                    brand, vertical.getCode(), Optional.ofNullable(data.getEnvironmentOverride())), endpoint, responseClass,
                    getApplyRequest(brand, data, payload, productId));
        } catch (ServiceConfigurationException | DaoException | IOException e) {
            throw new RouterException(e);
        }
    }

    public <RESPONSE> RESPONSE sendApplyRequest(Brand brand,
                                                   Vertical.VerticalType vertical,
                                                   String serviceName,
                                                   String endpoint, Request data,
                                                   PAYLOAD payload,
                                                   Class<RESPONSE> responseClass, String productId) throws RouterException {
        try {
            return restClient.sendPOSTRequest(getQuoteServiceProperties(serviceName,
                    brand, vertical.getCode(), Optional.ofNullable(data.getEnvironmentOverride())), endpoint, responseClass,
                    getApplyRequest(brand, data, payload, productId));
        } catch (ServiceConfigurationException | DaoException | IOException e) {
            throw new RouterException(e);
        }
    }

    protected RESPONSE sendRequestToService(Brand brand, Vertical.VerticalType vertical, String serviceName, Endpoint endpoint, Request data, Class<RESPONSE> responseClass,
                                          Object requestObj) throws ServiceConfigurationException, DaoException, IOException {
        QuoteServiceProperties serviceProperties = getQuoteServiceProperties(serviceName, brand, vertical.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        String jsonRequest = objectMapper.writeValueAsString(requestObj);

        // Log Request
        LOGGER.info("Sending request {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Outbound message {}", kv("request", jsonRequest));

        String response = restClient.setupSimplePOSTConnection(serviceProperties, jsonRequest)
                .get(serviceProperties.getServiceUrl() + "/" + endpoint.getValue());
        if (response == null) {
            throw new RouterException("Connection failed");
        }

        // Log response
        LOGGER.info("Receiving response {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Inbound message {}", kv("response", response));

        return objectMapper.readValue(response, objectMapper.constructType(responseClass));
    }


    protected RESPONSE sendGETRequestToService(Brand brand, Vertical.VerticalType vertical, String serviceName, Endpoint endpoint, String environmentOverride, TypeReference<RESPONSE> typeReference, Map<String, String> requestParams) throws ServiceConfigurationException, DaoException, IOException {

        QuoteServiceProperties serviceProperties = getQuoteServiceProperties(serviceName, brand, vertical.getCode(), Optional.ofNullable(environmentOverride));

        String params = Optional.ofNullable(requestParams)
                .orElse(Collections.emptyMap())
                .entrySet()
                .stream()
                .map(e -> e.getKey() + "=" + e.getValue())
                .collect(Collectors.joining("&"));

        // Log Request
        LOGGER.info("Sending request {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Outbound params {}", kv("params", params));

        String response = setupSimpleGETConnection(serviceProperties)
                .get(serviceProperties.getServiceUrl() + "/" + endpoint.getValue() + (StringUtils.isNotBlank(params) ? "?" : "") + (StringUtils.isNotBlank(params) ? params : ""));
        if (response == null) {
            throw new RouterException("Connection failed");
        }

        // Log response
        LOGGER.info("Receiving response {} {}", kv("vertical", vertical), kv("endpoint", endpoint));
        LOGGER.debug("Inbound message {}", kv("response", response));

        return objectMapper.readValue(response, typeReference);
    }

    private ApplyRequest getApplyRequest(Brand brand, Request data, PAYLOAD payload, String productId) {
        ApplyRequest.Builder<PAYLOAD> applyRequestBuilder= new ApplyRequest.Builder<>();
        applyRequestBuilder.productId(productId);
        applyRequestBuilder.brandCode(brand.getCode());
        applyRequestBuilder.clientIp(data.getClientIpAddress());
        applyRequestBuilder.transactionId(data.getTransactionId());
        applyRequestBuilder.payload(payload);
        return applyRequestBuilder.build();
    }

    private <PAYLOAD> com.ctm.web.core.providers.model.Request getQuoteRequest(Brand brand, Request data, PAYLOAD payload) {
        com.ctm.web.core.providers.model.Request<PAYLOAD> request = new com.ctm.web.core.providers.model.Request<>();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());
        request.setPayload(payload);
        request.setRequestAt(data.getRequestAt());
        return request;
    }


    private SimpleConnection setupSimpleGETConnection(QuoteServiceProperties serviceProperties) {
        SimpleConnection connection = new SimpleConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(serviceProperties.getTimeout());
        connection.setReadTimeout(serviceProperties.getTimeout());
        connection.setContentType("application/json");
        connection.setHasCorrelationId(true);
        return connection;
    }

    public QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Optional<String> environmentOverride) throws ServiceConfigurationException, DaoException {
        // Get URL of home-quote service
        final QuoteServiceProperties properties = new QuoteServiceProperties();
        ServiceConfiguration serviceConfig = getServiceConfiguration(service, brand, verticalCode);
        properties.setServiceUrl(serviceConfig.getPropertyValueByKey(SERVICE_URL, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
        properties.setDebugPath(serviceConfig.getPropertyValueByKey(DEBUG_PATH, ALL_BRANDS, ALL_PROVIDERS, SERVICE));
        String timeoutValue = serviceConfig.getPropertyValueByKey(TIMEOUT_MILLIS, ALL_BRANDS, ALL_PROVIDERS, SERVICE);
        if (timeoutValue != null) {
            properties.setTimeout(Integer.parseInt(timeoutValue));
        }

        environmentOverride.ifPresent(data -> {
            if (environment == EnvironmentService.Environment.LOCALHOST ||
                    environment == EnvironmentService.Environment.NXI) {
                if (StringUtils.isNotBlank(data)) {
                    properties.setServiceUrl(data);
                }
            }
        });

        return properties;

    }

    protected ServiceConfiguration getServiceConfiguration(String service, Brand brand, String verticalCode) throws DaoException, ServiceConfigurationException {
        if(serviceConfigurationService == null) {
            return ServiceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode).getId());
        }else {
            return serviceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode).getId());
        }
    }

}