package com.ctm.web.email.health;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.apache.commons.lang3.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Component
public class HealthModelTranslator implements EmailTranslator {

    public static final String VERTICAL_CODE = VerticalType.HEALTH.name().toLowerCase();
    private static final String CID = "em:cm:health:300994";
    private static final String ET_RID = "172883275";
    private static final String HEALTH_UTM_SOURCE = "health_quote_";
    private static final String UTM_MEDIUM = "email";
    private static final String CAMPAIGN = "health_quote";
    private static final String ACTION_UNSUBSCRIBE = "unsubscribe";
    private static final String ACTION_LOAD = "load";
    public static final int NUM_RESULTS = 14;

    private final EmailUtils emailUtils;
    private final ContentDao contentDao;
    private final OpeningHoursService openingHoursService;
    private final IPAddressHandler ipAddressHandler;

    @Autowired
    public HealthModelTranslator(EmailUtils emailUtils, ContentDao contentDao, OpeningHoursService openingHoursService, IPAddressHandler ipAddressHandler) {
        this.emailUtils = emailUtils;
        this.contentDao = contentDao;
        this.openingHoursService = openingHoursService;
        this.ipAddressHandler = ipAddressHandler;
    }

    @Override
    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws ConfigSettingException, DaoException {
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName", NUM_RESULTS);
        List<String> premiumLabel = EmailUtils.stripHtmlFromStrings.apply(emailUtils.buildParameterList(request, "rank_premiumText", NUM_RESULTS));
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider", NUM_RESULTS);
        List<String> premium = emailUtils.buildParameterList(request, "rank_premium", NUM_RESULTS);
        String gaclientId = emailUtils.getParamFromXml(data.getXML(), "gaclientid", "/health/");
        emailRequest.setVertical(VERTICAL_CODE);
        emailRequest.setProviders(providerName);
        emailRequest.setPremiumLabels(premiumLabel);
        emailRequest.setProviderCodes(providerCodes);
        emailRequest.setPremiums(premium);
        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
        emailRequest.setGaClientID(gaclientId);
        boolean isPopularProductsSelected = Optional.ofNullable(request.getParameter("isPopularProductsSelected")).map(BooleanUtils::toBoolean).orElse(false);
        emailRequest.setPopularProductsSelected(isPopularProductsSelected);

        List<BigDecimal> premiumDiscountPercentage = emailUtils.buildParameterList(request, "rank_premiumDiscountPercentage", NUM_RESULTS).stream().map(EmailUtils.bigDecimalOrZero).collect(Collectors.toList());
        emailRequest.setPremiumDiscountPercentage(premiumDiscountPercentage);

        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        String callCentreNumber = getCallCentreNumber(pageSettings);

        String benefitCodes = request.getParameter("rank_benefitCodes0");
        String extrasPds = request.getParameter("rank_extrasPdsUrl0");
        String coPayment = request.getParameter("rank_coPayment0");
        String excessPerPolicy = request.getParameter("rank_excessPerPolicy0");
        String excessPerAdmission = request.getParameter("rank_excessPerAdmission0");
        String hospitalPdsUrl = request.getParameter("rank_hospitalPdsUrl0");

        List<String> altPremium = emailUtils.buildParameterList(request, "rank_altPremium", NUM_RESULTS);
        List<String> altPremiumLabel = EmailUtils.stripHtmlFromStrings.apply(emailUtils.buildParameterList(request, "rank_altPremiumText", NUM_RESULTS));

        HealthEmailModel healthEmailModel = new HealthEmailModel();
        healthEmailModel.setBenefitCodes(benefitCodes);
        healthEmailModel.setCurrentCover(emailUtils.getParamSafely(data, VERTICAL_CODE + "/healthCover/primary/cover"));
        healthEmailModel.setNumberOfChildren(emailUtils.getParamSafely(data, VERTICAL_CODE + "/healthCover/dependants"));
        healthEmailModel.setProvider1Copayment(coPayment);
        healthEmailModel.setProvider1ExcessPerAdmission(excessPerAdmission);
        healthEmailModel.setProvider1ExcessPerPolicy(excessPerPolicy);
        healthEmailModel.setProvider1ExtrasPds(extrasPds);
        healthEmailModel.setProvider1HospitalPds(hospitalPdsUrl);
        healthEmailModel.setSituationType(emailUtils.getParamSafely(data, VERTICAL_CODE + "/situation/healthCvr"));
        healthEmailModel.setAltPremiumLabels(altPremiumLabel);
        healthEmailModel.setAltPremiums(altPremium);
        healthEmailModel.setPopPremiums(emailUtils.buildParameterList(request, "rank_popPremium", NUM_RESULTS));
        healthEmailModel.setPopPremiumLabels(emailUtils.buildParameterList(request, "rank_popPremiumLabel", NUM_RESULTS));
        healthEmailModel.setPopProviders(emailUtils.buildParameterList(request, "rank_popProvider", NUM_RESULTS));
        healthEmailModel.setPopProviderCodes(emailUtils.buildParameterList(request, "rank_popProviderCode", NUM_RESULTS));
        healthEmailModel.setPopProvider1HospitalPds(request.getParameter("rank_popProvider1HospitalPds"));
        healthEmailModel.setPopProvider1ExtrasPds(request.getParameter("rank_popProvider1ExtrasPds"));
        emailRequest.setHealthEmailModel(healthEmailModel);

        emailRequest.setCallCentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));

        List<String> providerPhones = new ArrayList<>();
        IntStream.range(EmailUtils.START, NUM_RESULTS).forEach(value -> providerPhones.add(callCentreNumber));
        emailRequest.setProviderPhoneNumbers(providerPhones);

        List<String> quoteRefs = new ArrayList<>();
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        IntStream.range(EmailUtils.START, NUM_RESULTS).forEach(value -> quoteRefs.add(transactionId.toString()));
        emailRequest.setQuoteRefs(quoteRefs);

        List<String> specialOffers = EmailUtils.stripHtmlFromStrings.apply(emailUtils.buildParameterList(request, "rank_specialOffer", NUM_RESULTS));
        emailRequest.setProviderSpecialOffers(specialOffers);
        setDataFields(emailRequest, data);
    }

    private void setDataFields(EmailRequest emailRequest, Data data) {
        String email = getEmail(data);
        String firstName = emailUtils.getParamSafely(data, VERTICAL_CODE + "/contactDetails/name");
        String fullAddress = emailUtils.getParamSafely(data, VERTICAL_CODE + "/application/address/fullAddress");
        emailRequest.setOptIn(getOptIn(data));
        String phoneNumber = emailUtils.getParamSafely(data, VERTICAL_CODE + "/contactDetails/contactNumber/mobile");
        emailRequest.setPhoneNumber(phoneNumber);

        emailRequest.setAddress(fullAddress);
        emailRequest.setFirstName(firstName);
        emailRequest.setEmailAddress(email);
    }

    public String getEmail(Data data) {
        return emailUtils.getParamSafely(data, VERTICAL_CODE + "/contactDetails/email");
    }

    public OptIn getOptIn(Data data) {
        String optIn = emailUtils.getParamSafely(data, VERTICAL_CODE + "/contactDetails/optInEmail");
        if (optIn != null) {
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
        EmailDetailsService emailDetailsService = EmailServiceFactory.createEmailDetailsService(SettingsService.getPageSettingsForPage(request), data, Vertical.VerticalType.HEALTH, new HealthEmailDetailMappings());
        EmailMaster emailMaster = emailDetailsService.handleReadAndWriteEmailDetails(Long.parseLong(emailRequest.getTransactionId()), emailDetails, "ONLINE", ipAddressHandler.getIPAddress(request));

        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        Map<String, String> emailParameters = new HashMap<>();
        Map<String, String> otherEmailParameters = new HashMap<>();
        otherEmailParameters.put(EmailUrlService.CID, CID);
        otherEmailParameters.put(EmailUrlService.ET_RID, ET_RID);
        otherEmailParameters.put(EmailUrlService.UTM_SOURCE, HEALTH_UTM_SOURCE + LocalDate.now().getYear());
        otherEmailParameters.put(EmailUrlService.UTM_MEDIUM, UTM_MEDIUM);
        otherEmailParameters.put(EmailUrlService.UTM_CAMPAIGN, CAMPAIGN);
        emailParameters.put(EmailUrlService.TRANSACTION_ID, emailRequest.getTransactionId());
        emailParameters.put(EmailUrlService.HASHED_EMAIL, emailMaster.getHashedEmail());
        emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, EMAIL_TYPE);
        emailParameters.put(EmailUrlService.VERTICAL, Optional.ofNullable(verticalCode).map(s -> s.toLowerCase()).orElse(null));

        // Create Unsubscribe link
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, ACTION_UNSUBSCRIBE);
        EmailUrlService urlService = EmailServiceFactory.createEmailUrlService(pageSettings, pageSettings.getVertical().getType());
        String unsubscribeUrl = urlService.getUnsubscribeUrl(emailParameters);

        // Create Load quote link
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, ACTION_LOAD);
        String applyUrl = urlService.getApplyUrl(emailMaster, emailParameters, otherEmailParameters);


        List<String> applyUrls = new ArrayList<>();
        IntStream.range(EmailUtils.START, NUM_RESULTS).forEach(applyUrl1 -> applyUrls.add(applyUrl));
        emailRequest.setApplyUrls(applyUrls);
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }

    private String getCallCentreNumber(PageSettings pageSettings) throws DaoException {
        int brandId = pageSettings.getBrandId();
        int verticalId = pageSettings.getVertical().getId();
        Content content = contentDao.getByKey("callCentreNumber", brandId, verticalId, ApplicationService.getServerDate(), false);
        return content != null ? content.getContentValue() : "";
    }
}
