package com.ctm.web.core.validator;

import com.ctm.web.core.model.request.ContactValidatorRequest;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.ContactValidatorService;
import com.ctm.web.core.services.SessionDataServiceBean;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class ContactValidator extends CommonQuoteRouter implements InitializingBean {

    private static ContactValidator INSTANCE;

    @Autowired
    private ContactValidatorService contactValidatorService;

    @Autowired
    public ContactValidator(SessionDataServiceBean sessionDataServiceBean) {
        super(sessionDataServiceBean);
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        INSTANCE = this;
    }

    public void validate(HttpServletRequest request, String verticalCode, ContactValidatorRequest validatorRequest) {
        final Vertical.VerticalType vertical = Vertical.VerticalType.findByCode(verticalCode);
        final Brand brand = initRouter(request, vertical);
        contactValidatorService.validateContact(brand, vertical, validatorRequest);
    }

    public static void validateFromJsp(HttpServletRequest request, String verticalCode, String contact) {
        if (StringUtils.isNotBlank(contact)) {
            ContactValidatorRequest validatorRequest = new ContactValidatorRequest();
            validatorRequest.setEnvironmentOverride(request.getParameter("environmentValidatorOverride"));
            validatorRequest.setContact(contact);
            INSTANCE.validate(request, verticalCode, validatorRequest);
        }
    }
}
