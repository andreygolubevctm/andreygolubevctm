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
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
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
    private static final String CID = "em:cm:health:300994";
    private static final String ET_RID = "172883275";
    private static final String HEALTH_UTM_SOURCE = "health_quote_";
    private static final String UTM_MEDIUM = "email";
    private static final String CAMPAIGN = "health_quote";
    private static final String EMAIL_TYPE = "bestprice";
    private static final String ACTION_UNSUBSCRIBE = "unsubscribe";

    @RequestMapping("/sendEmail")
    public void sendEmail(HttpServletRequest request, HttpServletResponse response){
        try {
            String dataXml = request.getParameter("data");
            String verticalCode = emailUtils.getParamFromXml(dataXml, "verticalCode", "/current/");
            String brand = emailUtils.getParamFromXml(dataXml, "brandCode", "/current/");
            if(VerticalType.HEALTH != VerticalType.valueOf(verticalCode)) return;
            SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            EmailRequest emailRequest = new EmailRequest();

            //String transactionId = request.getParameter("transactionId");
            Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
            Data data = sessionData.getSessionDataForTransactionId(transactionId);
            emailRequest.setTransactionId(transactionId.toString());
            emailRequest.setBrand(brand);


            if(VerticalType.HEALTH == VerticalType.valueOf(verticalCode)){
                healthModelTranslator.setHealthFields(emailRequest, request, data);
            }
            setUrls(request,emailRequest, data,verticalCode);
            emailClient.send(emailRequest);
        }
        catch(Exception e){
            LOGGER.error("Exception: " + e.getMessage());
        }
    }

    private void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException {
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setEmailAddress(emailRequest.getEmailAddress());
        emailDetails.setSource("QUOTE");
        OptIn optIn = healthModelTranslator.getOptIn(emailRequest,data);
        emailDetails.setOptedInMarketing(optIn == OptIn.Y, verticalCode);
        EmailDetailsService emailDetailsService = EmailServiceFactory.createEmailDetailsService(SettingsService.getPageSettingsForPage(request),data, Vertical.VerticalType.HEALTH, new HealthEmailDetailMappings());
        EmailMaster emailMaster = emailDetailsService.handleReadAndWriteEmailDetails(Long.parseLong(emailRequest.getTransactionId()), emailDetails, "ONLINE",  ipAddressHandler.getIPAddress(request));

        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        Map<String, String> emailParameters = new HashMap<>();
        Map<String, String> otherEmailParameters = new HashMap<>();
        otherEmailParameters.put(EmailUrlService.CID, CID);
        otherEmailParameters.put(EmailUrlService.ET_RID, ET_RID);
        otherEmailParameters.put(EmailUrlService.UTM_SOURCE, HEALTH_UTM_SOURCE + LocalDate.now().getYear());
        otherEmailParameters.put(EmailUrlService.UTM_MEDIUM, UTM_MEDIUM);
        otherEmailParameters.put(EmailUrlService.UTM_CAMPAIGN, CAMPAIGN);
        emailParameters.put(EmailUrlService.TRANSACTION_ID, emailRequest.getTransactionId());
        emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
        emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, EMAIL_TYPE);
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, ACTION_UNSUBSCRIBE);
        emailParameters.put(EmailUrlService.VERTICAL, Optional.ofNullable(verticalCode).map(s -> s.toLowerCase()).orElse(null));

        EmailUrlService urlService = EmailServiceFactory.createEmailUrlService(pageSettings, pageSettings.getVertical().getType());
        String unsubscribeUrl = urlService.getUnsubscribeUrl(emailParameters);
        String applyUrl = urlService.getApplyUrl(emailMaster,emailParameters,otherEmailParameters);
        List<String> applyUrls = new ArrayList<>();
        applyUrls.add(applyUrl);
        emailRequest.setApplyUrls(applyUrls);
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }
}
