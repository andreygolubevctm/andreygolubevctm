package com.ctm.web.core.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.formData.RequestWithQuote;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.HttpClientErrorException;

import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

public class CommonRequestServiceV2 {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonRequestServiceV2.class);

    protected static final String SERVICE_URL = "serviceUrl";
    protected static final String TIMEOUT_MILLIS = "timeoutMillis";
    protected static final String DEBUG_PATH = "debugPath";

    protected static final DateTimeFormatter EMAIL_DATE_FORMAT = DateTimeFormat.forPattern("dd MMMMM yyyy");
    protected static final DateTimeFormatter NORMAL_FORMAT = DateTimeFormat.forPattern("yyyy-MM-dd");

    private ProviderFilterDao providerFilterDAO;
    private ServiceConfigurationServiceBean serviceConfigurationService;

    private EnvironmentService.Environment environment;

    public CommonRequestServiceV2(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationService) {
        this.environment = EnvironmentService.getEnvironmentFromSpring();
        this.providerFilterDAO = providerFilterDAO;
        this.serviceConfigurationService = serviceConfigurationService;
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
        return serviceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode));
    }

    public void logHttpClientError(Throwable t) {
        if (t instanceof HttpClientErrorException) {
            HttpClientErrorException exception = (HttpClientErrorException) t;
            LOGGER.error("Backend Exception thrown {} {} {} ",
                    kv("httpStatusCode", exception.getStatusCode()),
                    kv("httpStatusText", exception.getStatusText()),
                    kv("message", exception.getResponseBodyAsString()));
        } else {
            LOGGER.error("Backend Exception thrown {} {} {} {} {}",
                    kv("class",t.getClass()),
                    kv("message",t.getMessage()),
                    kv("cause",t.getCause()),
                    kv("stacktrace",t.getStackTrace()),
                    t);
        }
    }

    public <QUOTE> void validateRequest(RequestWithQuote<QUOTE> data, String verticalCode) {
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
    }

}