package com.ctm.web.core.validator;

import com.ctm.validator.contacts.model.request.Contact;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ContactValidatorService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

public class ContactValidator {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContactValidator.class);


    public static void validateContact(HttpServletRequest request, String verticalCode, String contact) {
        try {
            if (StringUtils.isNotBlank(contact)) {
                final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
                final ContactValidatorService contactValidatorService = applicationContext.getBean(ContactValidatorService.class);
                final Vertical.VerticalType verticalType = Vertical.VerticalType.findByCode(verticalCode);
                contactValidatorService.validateContact(new ApplicationService().getBrand(request, verticalType), verticalType, Contact.instanceOf(contact),
                        Optional.ofNullable(request.getParameter("environmentValidatorOverride")));
            }
        } catch (Exception e) {
            LOGGER.warn("An error occurred while validating {} for {}", contact, verticalCode, e);
        }
    }
}
