package com.ctm.web.email;

import com.ctm.interfaces.common.types.VerticalType;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by akhurana on 15/09/17.
 */
@RestController
@RequestMapping("/marketing-automation/")
public class EmailController {

    private final SessionDataService sessionDataService = new SessionDataService();
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailController.class);

    @Autowired
    private HealthModelTranslator healthModelTranslator;
    @Autowired
    protected IPAddressHandler ipAddressHandler;
    @Autowired
    private EmailClient emailClient;
    @Autowired
    private CarModelTranslator carModelTranslator;
    @Autowired
    private TravelModelTranslator travelModelTranslator;

    @RequestMapping("/sendEmail.json")
    public void sendEmail(HttpServletRequest request) {

        try {
            final Brand brand = ApplicationService.getBrandFromRequest(request);
            final String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
            final Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
            LOGGER.info("Request received for brand: {}, vertical: {}, transaction: {}", brand, verticalCode, transactionId);

            final VerticalType verticalType = VerticalType.valueOf(verticalCode);
            if (VerticalType.HEALTH != verticalType
                    && VerticalType.CAR != verticalType
                    && VerticalType.TRAVEL != verticalType) {
                LOGGER.info("Unsupported vertical: {}. Not sending email request to marketing automation service.", verticalCode);
                return;
            }

            final SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            final Data data = sessionData.getSessionDataForTransactionId(transactionId);
            LOGGER.info("Session data: {}, for transaction: {}", data.toString(), transactionId);

            EmailRequest emailRequest = new EmailRequest();
            emailRequest.setFirstName(request.getParameter("name"));
            emailRequest.setAddress(request.getParameter("address"));
            emailRequest.setTransactionId(transactionId.toString());
            emailRequest.setBrand(brand.getCode());
            EmailTranslator emailTranslator = getEmailTranslator(verticalCode);
            emailTranslator.setVerticalSpecificFields(emailRequest, request, data);
            emailTranslator.setUrls(request, emailRequest, data, verticalCode);
            emailRequest.setVertical(verticalCode);

            emailClient.send(emailRequest);
        } catch (Exception e) {
            LOGGER.error(String.format("Unable to send email request for marketing automation service - Exception (%1$s): %2$s", e.getClass(), e.getMessage()));
        }
    }

    private EmailTranslator getEmailTranslator(String verticalCode) {
        VerticalType verticalType = VerticalType.valueOf(verticalCode);
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
