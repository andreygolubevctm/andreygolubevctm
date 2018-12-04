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
import com.ctm.web.email.car.CarModelTranslator;
import com.ctm.web.email.health.HealthModelTranslator;
import com.ctm.web.email.travel.TravelModelTranslator;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

@Service
public class MarketingAutomationEmailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(MarketingAutomationEmailService.class);
    private static final String NAME = "name";
    private static final String ADDRESS = "address";
    public static List<VerticalType> VALID_EMAIL_VERTICAL_LIST = Arrays.asList(VerticalType.HEALTH, VerticalType.TRAVEL, VerticalType.CAR);
    public static List<VerticalType> VALID_EMAIL_EVENT_VERTICAL_LIST = Arrays.asList(VerticalType.HEALTH);

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
        final Optional<Brand> brand = Optional.ofNullable(ApplicationService.getBrandFromRequest(request));
        final String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
        final Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        if (!isValidRequest(verticalCode, brand.map(s->s.getCode()).orElse(null), transactionId, VALID_EMAIL_VERTICAL_LIST)) return;

        LOGGER.info("Request received for brand: {}, vertical: {}, transaction: {}", brand.map(s->s.getCode()).orElse(null), verticalCode, transactionId);

        final SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        final Data data = sessionData.getSessionDataForTransactionId(transactionId);

        EmailRequest emailRequest = getEmailRequest(request, brand.get(), transactionId);
		emailRequest.setVertical(verticalCode);
        EmailTranslator emailTranslator = getEmailTranslator(verticalCode);
        emailTranslator.setVerticalSpecificFields(emailRequest, request, data);

        if (attemptEmailDistribution(emailRequest)) {
			emailTranslator.setUrls(request, emailRequest, data, verticalCode);
            emailClient.send(emailRequest);
        }
    }

    public EmailResponse sendEventEmail(EmailEventRequest emailEventRequest){
        boolean invalidRequest = !isValidRequest(emailEventRequest.getVerticalCode(), emailEventRequest.getBrand(), Long.valueOf(emailEventRequest.getTransactionId()), VALID_EMAIL_EVENT_VERTICAL_LIST);
        boolean attemptEmail = attemptEmailDistribution(emailEventRequest);
        if (invalidRequest || !attemptEmail) {
            final EmailResponse response = new EmailResponse();
            response.setSuccess(false);
            String invalidRequestMsg = "Invalid request. Vertical, Brand or transactionId is invalid or unsupported";
            String invalidEmailMsg = "Invalid email address (" + emailEventRequest.getEmailAddress() + ") provided with request";
            if(!invalidRequest && !attemptEmail) {
                response.setMessage(invalidRequestMsg + " and " + invalidEmailMsg);
            } else if(!invalidRequest) {
                response.setMessage(invalidRequestMsg);
            } else {
                response.setMessage(invalidEmailMsg);
            }
            return response;
        }
        return emailClient.send(emailEventRequest);
    }

    protected static boolean isValidRequest(final String verticalCode, final String brand, final Long transactionId, List<VerticalType> validVerticalList) {
        final VerticalType verticalType = getVerticalType(verticalCode);

        if (StringUtils.isBlank(verticalCode) || brand == null || transactionId == null) {
            LOGGER.warn("Invalid request. Blank: VerticalCode: {}, brand: {}, transactionId: {}", verticalCode, brand, transactionId);
            return false;
        }

        if (brand != null && brand.equalsIgnoreCase("choo")) {
            LOGGER.warn("Invalid request. No emails for Choosi brand: VerticalCode: {}, brand: {}, transactionId: {}", verticalCode, brand, transactionId);
            return false;
        }

        if (!validVerticalList.contains(verticalType)) {
            LOGGER.info("Unsupported vertical: {}. Not sending email request to marketing automation service.", verticalCode);
            return false;
        }
        return true;
    }

    protected static boolean attemptEmailDistribution(EmailEventRequest emailEventRequest){
        String email = emailEventRequest.getEmailAddress();
        return StringUtils.isNotBlank(email) && EmailUtils.isValidEmailAddress(email);
    }

    protected static boolean attemptEmailDistribution(EmailRequest emailRequest){
        String email = emailRequest.getEmailAddress();
        if(StringUtils.isNotBlank(email) && EmailUtils.isValidEmailAddress(email)){
            if(VerticalType.HEALTH != getVerticalType(emailRequest.getVertical()) || !emailRequest.isPopularProductsSelected()) {
                return true;
            }
        }
        return false;
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
