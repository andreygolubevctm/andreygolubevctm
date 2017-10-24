package com.ctm.web.email;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.health.CarModelTranslator;
import com.ctm.web.email.health.HealthModelTranslator;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.*;

/**
 * Created by akhurana on 15/09/17.
 */
@RestController
@RequestMapping("/marketing-automation/")
public class EmailController {

    private MarketingEmailService emailService;
    private final SessionDataService sessionDataService = new SessionDataService();
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailController.class);

    @Autowired
    private EmailUtils emailUtils;
    @Autowired
    private HealthModelTranslator healthModelTranslator;
    @Autowired
    protected IPAddressHandler ipAddressHandler;
    @Autowired
    private EmailClient emailClient;
    @Autowired
    private CarModelTranslator carModelTranslator;

    private static final String CID = "em:cm:health:300994";
    private static final String ET_RID = "172883275";
    private static final String HEALTH_UTM_SOURCE = "health_quote_";
    private static final String UTM_MEDIUM = "email";
    private static final String CAMPAIGN = "health_quote";
    private static final String EMAIL_TYPE = "bestprice";
    private static final String ACTION_UNSUBSCRIBE = "unsubscribe";

    @RequestMapping("/sendEmail.json")
    public void sendEmail(HttpServletRequest request, HttpServletResponse response){
        try {
            Brand brand = ApplicationService.getBrandFromRequest(request);
            String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
            if (VerticalType.HEALTH != VerticalType.valueOf(verticalCode) && VerticalType.CAR != VerticalType.valueOf(verticalCode))
                return;
            SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            EmailRequest emailRequest = new EmailRequest();

            //String transactionId = request.getParameter("transactionId");
            Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
            Data data = sessionData.getSessionDataForTransactionId(transactionId);
            emailRequest.setFirstName(request.getParameter("name"));
            emailRequest.setAddress(request.getParameter("address"));
            emailRequest.setTransactionId(transactionId.toString());
            emailRequest.setBrand(brand.getCode());
            List<String> quoteRefs = new ArrayList<>();
            quoteRefs.add(transactionId.toString());
            emailRequest.setQuoteRefs(quoteRefs);
            EmailTranslator emailTranslator = getEmailTranslator(verticalCode);
            emailTranslator.setVerticalSpecificFields(emailRequest, request, data);
            emailTranslator.setUrls(request, emailRequest, data, verticalCode,null);
            emailRequest.setVertical(verticalCode);

            emailClient.send(emailRequest);
        }
        catch(Exception e){
            LOGGER.error("Exception: " + e.getMessage());
        }
    }

    private EmailTranslator getEmailTranslator(String verticalCode){
        VerticalType verticalType = VerticalType.valueOf(verticalCode);
        if(VerticalType.HEALTH == verticalType){
            return healthModelTranslator;
        }
        else if(VerticalType.CAR == verticalType){
            return carModelTranslator;
        }
        throw new RuntimeException("Vertical not supported");
    }
}
