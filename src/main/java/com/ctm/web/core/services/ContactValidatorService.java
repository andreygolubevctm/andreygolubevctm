package com.ctm.web.core.services;

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

import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class ContactValidatorService extends CommonRequestService {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContactValidatorService.class);

    @Autowired
    public ContactValidatorService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
        super(providerFilterDAO, objectMapper);
    }

    public ContactValidatorService() {
        super(new ProviderFilterDao(), ObjectMapperUtil.getObjectMapper());
    }

    @Async
    public void validateContact(Brand brand, Vertical.VerticalType verticalType, Contact contact, Optional<String> environmentOverride) {
        try {

            final ValidateContactResponse response = getRestClient().sendPOSTRequest(
                    getQuoteServiceProperties("contactValidatorService", brand, verticalType.getCode(), environmentOverride),
                    verticalType,
                    Endpoint.VALIDATE,
                    ValidateContactResponse.class,
                    new ValidateContactRequest(contact));
            LOGGER.debug("ValidateContact executed {} {}", kv("response", response));
        } catch (Exception e) {
            LOGGER.warn("Exception occurred while validating {}:", kv("contact", contact), e);
        }
    }

}
