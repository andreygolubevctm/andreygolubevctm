package com.ctm.web.core.services;

import com.ctm.commonlogging.context.LoggingContext;
import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.validator.contacts.model.request.Contact;
import com.ctm.validator.contacts.model.request.ValidateContactRequest;
import com.ctm.validator.contacts.model.response.ValidateContactResponse;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.model.request.ContactValidatorRequest;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.utils.ObjectMapperUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class ContactValidatorService extends CommonRequestService<ValidateContactRequest, ValidateContactResponse> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContactValidatorService.class);

    @Autowired
    public ContactValidatorService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public ContactValidatorService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    @Async
    public void validateContact(Brand brand, Vertical.VerticalType verticalType, ContactValidatorRequest contactValidatorRequest, LoggingContext loggingContext) {
        try {
            LoggingVariables.setLoggingContext(loggingContext);
            final ValidateContactResponse response = sendRequestToService(brand, verticalType, "contactValidatorService", Endpoint.VALIDATE,
                    contactValidatorRequest, ValidateContactResponse.class, new ValidateContactRequest(Contact.instanceOf(contactValidatorRequest.getContact())));
            LOGGER.debug("ValidateContact executed {} {}", kv("response", response));
        } catch (Exception e) {
            LOGGER.warn("Exception occurred while validating {}:", kv("contactValidatorRequest", contactValidatorRequest), e);
        } finally {
            LoggingVariables.clearLoggingContext();
        }
    }

}