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
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
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
import java.util.stream.IntStream;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class HealthModelTranslator implements EmailTranslator {

    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.HEALTH.name().toLowerCase();
    private static final VerticalType verticalCode = VerticalType.HEALTH;
    @Autowired
    protected IPAddressHandler ipAddressHandler;

    private static final String CID = "em:cm:health:300994";
    private static final String ET_RID = "172883275";
    private static final String HEALTH_UTM_SOURCE = "health_quote_";
    private static final String UTM_MEDIUM = "email";
    private static final String CAMPAIGN = "health_quote";
    private static final String EMAIL_TYPE = "bestprice";
    private static final String ACTION_UNSUBSCRIBE = "unsubscribe";

    @Override
    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws ConfigSettingException, DaoException {
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName");
        List<String> premiumLabel = emailUtils.buildParameterList(request, "rank_premiumText");
        List<String> premium = emailUtils.buildParameterList(request, "rank_premium");
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider");
        String gaclientId = emailUtils.getParamFromXml(data.getXML(), "gaclientid", "/health/");
        emailRequest.setVertical(vertical);
        emailRequest.setProviders(providerName);
        emailRequest.setPremiumLabels(premiumLabel);
        emailRequest.setProviderCodes(providerCodes);
        emailRequest.setPremiums(premium);
        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
        emailRequest.setGaClientID(gaclientId);

        String benefitCodes = request.getParameter("rank_benefitCodes0");
        String extrasPds = request.getParameter("rank_extrasPdsUrl0");
        String coPayment =  request.getParameter("rank_coPayment0");
        String excessPerPolicy = request.getParameter("rank_excessPerPolicy0");
        String excessPerAdmission = request.getParameter("rank_excessPerAdmission0");
        String hospitalPdsUrl = request.getParameter("rank_hospitalPdsUrl0");
        String specialOffer = request.getParameter("rank_specialOffer0");
        List<String> specialOffers = new ArrayList<>();
        specialOffers.add(specialOffer);

        HealthEmailModel healthEmailModel = new HealthEmailModel();
        OpeningHoursService openingHoursService = new OpeningHoursService();
        healthEmailModel.setBenefitCodes(benefitCodes);
        healthEmailModel.setCurrentCover(emailUtils.getParamSafely(data,vertical + "/healthCover/primary/cover"));
        healthEmailModel.setNumberOfChildren(emailUtils.getParamSafely(data,vertical + "/healthCover/dependants"));
        healthEmailModel.setProvider1Copayment(coPayment);
        healthEmailModel.setProvider1ExcessPerAdmission(excessPerAdmission);
        healthEmailModel.setProvider1ExcessPerPolicy(excessPerPolicy);
        healthEmailModel.setProvider1ExtrasPds(extrasPds);
        healthEmailModel.setProvider1HospitalPds(hospitalPdsUrl);
        healthEmailModel.setSituationType(emailUtils.getParamSafely(data,vertical + "/situation/healthCvr"));

        emailRequest.setHealthEmailModel(healthEmailModel);
        emailRequest.setCallCentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
        List<String> quoteRefs = new ArrayList<>();
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        IntStream.range(1,10).forEach(value -> quoteRefs.add(transactionId.toString()));
        emailRequest.setQuoteRefs(quoteRefs);
        emailRequest.setProviderSpecialOffers(specialOffers);
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
