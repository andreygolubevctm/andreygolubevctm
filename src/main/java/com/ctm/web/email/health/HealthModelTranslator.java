package com.ctm.web.email.health;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.*;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class HealthModelTranslator implements EmailTranslator{

    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.HEALTH.name().toLowerCase();
    private static final VerticalType verticalCode = VerticalType.HEALTH;
    @Autowired
    protected IPAddressHandler ipAddressHandler;

    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data){
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName");
        List<String> premiumLabel = emailUtils.buildParameterList(request, "rank_premiumText");
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider");
        emailRequest.setProviders(providerName);
        emailRequest.setPremiumLabels(premiumLabel);
        emailRequest.setProviderCodes(providerCodes);

        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));

        String benefitCodes = request.getParameter("rank_benefitCodes0");
        String primaryCurrentPHI0 = request.getParameter("rank_primaryCurrentPHI0");
        String extrasPdsUrl = request.getParameter("rank_extrasPdsUrl0");
        String coPayment =  request.getParameter("rank_coPayment0");
        String excessPerPerson = request.getParameter("rank_excessPerPerson0");
        String excessPerPolicy = request.getParameter("rank_excessPerPolicy0");
        String healthMembership = request.getParameter("rank_healthMembership0");
        String excessPerAdmission = request.getParameter("rank_excessPerAdmission0");
        String hospitalPdsUrl = request.getParameter("rank_hospitalPdsUrl0");
        String coverType = request.getParameter("rank_coverType0");
        String dataXml = request.getParameter("data");
        String gaclientId = emailUtils.getParamFromXml(dataXml, "gaclientid", "/health/");

        HealthEmailModel healthEmailModel = new HealthEmailModel();
        healthEmailModel.setCoverType(coverType);
        healthEmailModel.setBenefitCodes(benefitCodes);
        healthEmailModel.setPrimaryCurrentPHI(primaryCurrentPHI0);
        healthEmailModel.setP1ExtrasPdsUrl(extrasPdsUrl);
        healthEmailModel.setP1Copayment(coPayment);
        healthEmailModel.setP1ExcessPerPerson(excessPerPerson);
        healthEmailModel.setP1ExcessPerPolicy(excessPerPolicy);
        healthEmailModel.setHealthMembership(healthMembership);
        healthEmailModel.setP1ExcessPerAdmission(excessPerAdmission);
        healthEmailModel.setP1HospitalPdsUrl(hospitalPdsUrl);
        healthEmailModel.setNumberOfChildren(emailUtils.getParamSafely(data,vertical + "/healthCover/dependants"));
        healthEmailModel.setSituationType(emailUtils.getParamSafely(data,vertical + "/situation/healthCvr"));
        healthEmailModel.setCurrentCover(emailUtils.getParamSafely(data,vertical + "/healthCover/primary/cover"));
        emailRequest.setGaClientID(gaclientId);
        emailRequest.setHealthEmailModel(Optional.of(healthEmailModel));
        setDataFields(emailRequest, data);
    }

    private void setDataFields(EmailRequest emailRequest, Data data){
        String email = getEmail(data);
        String firstName = emailUtils.getParamSafely(data,vertical + "/contactDetails/name");
        String fullAddress = emailUtils.getParamSafely(data,vertical + "/application/address/fullAddress");
        emailRequest.setOptIn(getOptIn(data));
        String phoneNumber = emailUtils.getParamSafely(data,vertical + "/contactDetails/contactNumber/mobile");
        emailRequest.setPhoneNumber(phoneNumber);

        emailRequest.setAddress(fullAddress);
        emailRequest.setFirstName(firstName);
        emailRequest.setEmailAddress(email);
    }

    public String getEmail(Data data){
        return emailUtils.getParamSafely(data,vertical + "/contactDetails/email");
    }

    public OptIn getOptIn(Data data){
        String optIn = emailUtils.getParamSafely(data,vertical + "/contactDetails/optInEmail");
        if(optIn!=null){
            return OptIn.valueOf(optIn);
        }
        return OptIn.N;
    }

    @Override
    public void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException {
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setEmailAddress(emailRequest.getEmailAddress());
        emailDetails.setSource("QUOTE");
        OptIn optIn = getOptIn(data);
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
        emailRequest.setApplyUrls(applyUrls);
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }
}
