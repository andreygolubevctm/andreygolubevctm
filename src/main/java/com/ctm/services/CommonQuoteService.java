package com.ctm.services;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.ServiceException;
import com.ctm.model.QuoteServiceProperties;
import com.ctm.model.formData.Request;
import com.ctm.model.settings.*;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.Optional;

import static com.ctm.model.settings.ConfigSetting.ALL_BRANDS;
import static com.ctm.model.settings.ServiceConfigurationProperty.ALL_PROVIDERS;
import static com.ctm.model.settings.ServiceConfigurationProperty.Scope.SERVICE;

public abstract class CommonQuoteService<T> {

    public static final String SERVICE_URL = "serviceUrl";
    public static final String TIMEOUT_MILLIS = "timeoutMillis";
    public static final String DEBUG_PATH = "debugPath";

    private boolean valid = false;

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
