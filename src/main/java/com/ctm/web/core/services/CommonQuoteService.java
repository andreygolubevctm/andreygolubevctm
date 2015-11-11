package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.formData.Request;
import com.ctm.web.core.model.settings.*;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

public abstract class CommonQuoteService<T> {

    public static final String SERVICE_URL = "serviceUrl";
    public static final String TIMEOUT_MILLIS = "timeoutMillis";
    public static final String DEBUG_PATH = "debugPath";
    private ServiceConfiguration serviceConfig;

    private boolean valid = false;

    public CommonQuoteService(ServiceConfiguration serviceConfig) {
        this.serviceConfig = serviceConfig;
    }

    public CommonQuoteService() {
    }

    public List<SchemaValidationError> validateRequest(Request<T> data, String vertical) {
        List<SchemaValidationError> errors = FormValidation.validate(data.getQuote(), vertical);
        valid = errors.isEmpty();
        return errors;
    }

    public QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Request<T> request) {
        return getQuoteServiceProperties(service, brand, verticalCode, Optional.ofNullable(request.getEnvironmentOverride()));
    }

    public QuoteServiceProperties getQuoteServiceProperties(String service, Brand brand, String verticalCode, Optional<String> environmentOverride) {
        // Get URL of home-quote service
        final QuoteServiceProperties properties = new QuoteServiceProperties();
        try {
            if(serviceConfig == null) {
                this.serviceConfig = ServiceConfigurationService.getServiceConfiguration(service, brand.getVerticalByCode(verticalCode).getId(), brand.getId());
            }
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

    public boolean isValid() {
        return valid;
    }

}
