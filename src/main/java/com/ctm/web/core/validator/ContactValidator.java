package com.ctm.web.core.validator;

import com.ctm.commonlogging.context.LoggingContext;
import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.web.core.model.request.ContactValidatorRequest;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ContactValidatorService;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class ContactValidator extends CommonQuoteRouter implements InitializingBean {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContactValidator.class);

    private static ContactValidator INSTANCE;

    @Autowired
    private ContactValidatorService contactValidatorService;

    @Autowired
    public ContactValidator(SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean,  ipAddressHandler);
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        INSTANCE = this;
    }

    public void validate(HttpServletRequest request, String verticalCode, ContactValidatorRequest validatorRequest) {
        final Vertical.VerticalType vertical = Vertical.VerticalType.findByCode(verticalCode);
        final Brand brand = initRouter(request, vertical);
        final LoggingContext loggingContext = LoggingVariables.getLoggingContext();
        contactValidatorService.validateContact(brand, vertical, validatorRequest, loggingContext);
    }

    public static void validateContact(HttpServletRequest request, String verticalCode, String contact) {
        try {
            if (StringUtils.isNotBlank(contact)) {
                ContactValidatorRequest validatorRequest = new ContactValidatorRequest();
                validatorRequest.setEnvironmentOverride(request.getParameter("environmentValidatorOverride"));
                validatorRequest.setContact(contact);
                INSTANCE.validate(request, verticalCode, validatorRequest);
            }
        } catch (Exception e) {
            LOGGER.warn("An error occurred while validating {} for {}", contact, verticalCode, e);
        }
    }
}