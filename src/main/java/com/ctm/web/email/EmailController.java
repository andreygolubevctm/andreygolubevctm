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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @RequestMapping("/sendEmail")
    public void sendEmail(HttpServletRequest request, HttpServletResponse response){
        try {
            String dataXml = request.getParameter("data");
            String verticalCode = emailUtils.getParamFromXml(dataXml, "verticalCode", "/current/");
            String brand = emailUtils.getParamFromXml(dataXml, "brandCode", "/current/");
            if(VerticalType.HEALTH != VerticalType.valueOf(verticalCode)) return;
            SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            EmailRequest emailRequest = new EmailRequest();

            String transactionId = request.getParameter("transactionId");
            Data data = sessionData.getSessionDataForTransactionId(transactionId);
            emailRequest.setFirstName(request.getParameter("name"));
            emailRequest.setAddress(request.getParameter("address"));
            emailRequest.setTransactionId(transactionId);
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
        otherEmailParameters.put(EmailUrlService.CID, "em:cm:health:300994");
        otherEmailParameters.put(EmailUrlService.ET_RID, "172883275");
        otherEmailParameters.put(EmailUrlService.UTM_SOURCE, "health_quote_" + LocalDate.now().getYear());
        otherEmailParameters.put(EmailUrlService.UTM_MEDIUM, "email");
        otherEmailParameters.put(EmailUrlService.UTM_CAMPAIGN, "health_quote");
        emailParameters.put(EmailUrlService.TRANSACTION_ID, emailRequest.getTransactionId());
        emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
        emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
        emailParameters.put(EmailUrlService.VERTICAL, "health");

        EmailUrlService urlService = EmailServiceFactory.createEmailUrlService(pageSettings, pageSettings.getVertical().getType());
        String unsubscribeUrl = urlService.getUnsubscribeUrl(emailParameters);
        String applyUrl = urlService.getApplyUrl(emailMaster,emailParameters,otherEmailParameters);
        List<String> applyUrls = new ArrayList<>();
        applyUrls.add(applyUrl);
        emailRequest.setApplyUrl(applyUrls);
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }
}
