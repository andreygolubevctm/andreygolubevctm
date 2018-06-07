package com.ctm.web.email;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.health.CarModelTranslator;
import com.ctm.web.email.health.HealthModelTranslator;
import com.ctm.web.email.health.TravelModelTranslator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;

@Service
public class MarketingAutomationEmailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MarketingAutomationEmailService.class);
    private static final String NAME = "name";
    private static final String ADDRESS = "address";

    private final SessionDataService sessionDataService = new SessionDataService();
    @Autowired
    protected IPAddressHandler ipAddressHandler;
    @Autowired
    private HealthModelTranslator healthModelTranslator;
    @Autowired
    private EmailClient emailClient;
    @Autowired
    private CarModelTranslator carModelTranslator;
    @Autowired
    private TravelModelTranslator travelModelTranslator;

    public void sendEmail(HttpServletRequest request) throws DaoException, ConfigSettingException, EmailDetailsException, SendEmailException, GeneralSecurityException {
        LOGGER.info("Request received");

        final Brand brand = ApplicationService.getBrandFromRequest(request);
        final String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
        final Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        if (!isValidRequest(verticalCode, brand, transactionId)) return;

        LOGGER.info("Request received for brand: {}, vertical: {}, transaction: {}", brand.getCode(), verticalCode, transactionId);

        final SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        final Data data = sessionData.getSessionDataForTransactionId(transactionId);
        LOGGER.info("Session data: {}, for transaction: {}", data.toString(), transactionId);

        EmailRequest emailRequest = getEmailRequest(request, brand, transactionId);

        EmailTranslator emailTranslator = getEmailTranslator(verticalCode);
        emailTranslator.setVerticalSpecificFields(emailRequest, request, data);
        emailTranslator.setUrls(request, emailRequest, data, verticalCode);
        emailRequest.setVertical(verticalCode);

        if (VerticalType.HEALTH != VerticalType.valueOf(verticalCode) || !emailRequest.isPopularProductsSelected()) {
            LOGGER.info("Marketing Automation Service request payload: {}", emailRequest.toString());
            emailClient.send(emailRequest);
        }
    }

    protected static boolean isValidRequest(final String verticalCode, final Brand brand, final Long transactionId) {

        final VerticalType verticalType = getVerticalType(verticalCode);

        if (StringUtils.isBlank(verticalCode) || brand == null || transactionId == null) {
            LOGGER.warn("Invalid request. Blank: VerticalCode: {}, brand: {}, transactionId: {}", verticalCode, brand, transactionId);
            return false;
        }

        if (VerticalType.HEALTH != verticalType
                && VerticalType.CAR != verticalType
                && VerticalType.TRAVEL != verticalType) {
            LOGGER.info("Unsupported vertical: {}. Not sending email request to marketing automation service.", verticalCode);
            return false;
        }
        return true;
    }

    private static VerticalType getVerticalType(final String verticalCode) {

        if (org.apache.commons.lang3.StringUtils.isBlank(verticalCode)) {
            LOGGER.warn("Unable to get vertical type. Blank vertical code.");
            return null;
        }

        try {
            return VerticalType.valueOf(verticalCode.toUpperCase());
        } catch (IllegalArgumentException e) {
            LOGGER.warn("Unable to get vertical type from code: {}", verticalCode);
            return null;
        }
    }

    protected static EmailRequest getEmailRequest(HttpServletRequest request, Brand brand, Long transactionId) {
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setFirstName(request.getParameter(NAME));
        emailRequest.setAddress(request.getParameter(ADDRESS));
        emailRequest.setTransactionId(transactionId.toString());
        emailRequest.setBrand(brand.getCode());
        return emailRequest;
    }

    private EmailTranslator getEmailTranslator(String verticalCode) {
        final VerticalType verticalType = getVerticalType(verticalCode);
        if (VerticalType.HEALTH == verticalType) {
            return healthModelTranslator;
        } else if (VerticalType.CAR == verticalType) {
            return carModelTranslator;
        } else if (VerticalType.TRAVEL == verticalType) {
            return travelModelTranslator;
        }
        throw new RuntimeException("Vertical not supported");
    }
}
