package com.ctm.web.email.health;

import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailController;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.email.car.CarEmailModel;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.validation.ValidationException;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static java.lang.Integer.min;

/**
 * Created by akhurana on 25/09/17.
 */
@Component
public class CarModelTranslator implements EmailTranslator {

    @Autowired
    private EmailUtils emailUtils;
    private DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    @Autowired
    protected IPAddressHandler ipAddressHandler;

    private static final Logger LOGGER = LoggerFactory.getLogger(CarModelTranslator.class);

    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws RuntimeException, DaoException {

        List<String> providerNames = new ArrayList<>();
        List<String> providerPhoneNumbers = new ArrayList<>();
        List<String> premiums = new ArrayList<>();
        List<String> brandCodes = new ArrayList<>();
        List<String> excesses = new ArrayList<>();
        List<String> validDates = new ArrayList<>();
        List<String> discountOffers = new ArrayList<>();
        List<String> headlineOffers = new ArrayList<>();
        List<String> quoteRefs = new ArrayList<>();

        List<EmailParameters> truncatedEmailParameters = getSortedTruncatedEmailParameters(emailRequest,data);

        truncatedEmailParameters.forEach(emailParameter -> providerNames.add(emailParameter.getProviderName()));
        truncatedEmailParameters.forEach(emailParameter -> providerPhoneNumbers.add(emailParameter.getProviderPhoneNumber()));
        truncatedEmailParameters.forEach(emailParameter -> premiums.add(emailParameter.getPremium()));
        truncatedEmailParameters.forEach(emailParameter -> brandCodes.add(emailParameter.getBrandCode()));
        truncatedEmailParameters.forEach(emailParameter -> excesses.add(emailParameter.getExcess()));
        truncatedEmailParameters.forEach(emailParameter -> validDates.add(emailParameter.getValidDate()));
        truncatedEmailParameters.forEach(emailParameter -> discountOffers.add(emailParameter.getDiscountOffer()));
        truncatedEmailParameters.forEach(emailParameter -> headlineOffers.add(emailParameter.getHeadlineOffer()));
        truncatedEmailParameters.forEach(emailParameter -> quoteRefs.add(emailParameter.getQuoteRef()));

        emailRequest.setProviders(providerNames);
        emailRequest.setProviderPhoneNumbers(providerPhoneNumbers);
        emailRequest.setProductDescriptions(providerNames);
        emailRequest.setProviderCodes(brandCodes);
        emailRequest.setExcesses(excesses);
        emailRequest.setValidDates(validDates);
        emailRequest.setProviderSpecialOffers(discountOffers);
        emailRequest.setPremiums(premiums);
        emailRequest.setQuoteRefs(quoteRefs);

        String commencementDate = emailUtils.getParamSafely(data, "/options/commencementDate");
        String firstName = emailUtils.getParamSafely(data, "/drivers/regular/firstname");
        String lastName = emailUtils.getParamSafely(data, "/drivers/regular/surname");
        String phoneNumber = emailUtils.getParamSafely(data, "/contact/phone");
        String typeOfCover = emailUtils.getParamSafely(data, "quote/optionsTypeOfCover");
        String make = emailUtils.getParamSafely(data, "/vehicle/makeDes");
        String model = emailUtils.getParamSafely(data, "/vehicle/modelDes");
        String vehicleVariant = emailUtils.getParamSafely(data, "/vehicle/variant");
        String vehicleYear = emailUtils.getParamSafely(data, "/vehicle/year");
        String optIn = emailUtils.getParamSafely(data, "/contact/marketing");
        String address = emailUtils.getParamSafely(data, "quote/riskAddress/fullAddress");
        String gaClientId = emailUtils.getParamSafely(data, "/gaclientid");
        List<String> premiumLables = emailUtils.getPremiumLabels(headlineOffers);

        emailRequest.setOptIn(OptIn.valueOf(optIn));
        emailRequest.setCommencementDate(LocalDate.parse(commencementDate, dateTimeFormatter));
        emailRequest.setFirstName(firstName);
        emailRequest.setLastName(lastName);
        emailRequest.setPhoneNumber(phoneNumber);
        emailRequest.setAddress(address);
        emailRequest.setGaClientID(gaClientId);
        emailRequest.setPremiumLabels(premiumLables);

        CarEmailModel carEmailModel = new CarEmailModel();
        carEmailModel.setCoverType(typeOfCover);
        carEmailModel.setVehicleMake(make);
        carEmailModel.setVehicleModel(model);
        carEmailModel.setVehicleVariant(vehicleVariant);
        carEmailModel.setVehicleYear(vehicleYear);
        emailRequest.setCarEmailModel(carEmailModel);

        if (!truncatedEmailParameters.isEmpty() && StringUtils.isNotBlank(truncatedEmailParameters.get(0).getOpeningHour())){
            emailRequest.setCallCentreHours(truncatedEmailParameters.get(0).getOpeningHour());
        }
        String email = getEmail(data);
        if (!StringUtils.isBlank(email)) emailRequest.setEmailAddress(email);
    }

    private List<String> getAllResultProperties(List<ResultProperty> resultProperties, String property) {
        return resultProperties.stream().filter(resultProperty -> resultProperty.getProperty().equals(property))
                .map(resultProperty -> resultProperty.getValue()).collect(Collectors.toList());
    }

    private String getResultProperty(List<ResultProperty> resultProperties, String property, String productId) {
        return resultProperties.stream().filter(resultProperty -> resultProperty.getProperty().equals(property) && productId.equals(resultProperty.getProductId()))
                .map(resultProperty -> resultProperty.getValue()).findFirst().orElse(null);
    }

    public String getEmail(Data data) {
        return emailUtils.getParamSafely(data, "/contact/email");
    }

    @Override
    public void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException, GeneralSecurityException {
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setEmailAddress(emailRequest.getEmailAddress());
        emailDetails.setSource("QUOTE");

        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(pageSettings);
        EmailDetailsService emailDetailsService = EmailServiceFactory.createEmailDetailsService(SettingsService.getPageSettingsForPage(request),data, Vertical.VerticalType.HEALTH, new HealthEmailDetailMappings());
        EmailMaster emailMaster = emailDetailsService.handleReadAndWriteEmailDetails(Long.parseLong(emailRequest.getTransactionId()), emailDetails, "ONLINE",  ipAddressHandler.getIPAddress(request));

        emailTokenService.insertEmailTokenRecord(Long.parseLong(emailRequest.getTransactionId()), emailMaster.getHashedEmail(), pageSettings.getBrandId(),
                "bestprice", "load");
        String baseUrl = pageSettings.getBaseUrl();

        List<String> productIds = getSortedTruncatedEmailParameters(emailRequest,data).stream().map(emailParameters -> emailParameters.getProductId()).collect(Collectors.toList());
        List<String> applyUrls = productIds.stream().map(s -> {
            return generateBestPriceUrl(emailTokenService,emailRequest, emailMaster, pageSettings,s,baseUrl);
        }).collect(Collectors.toList());
        emailRequest.setApplyUrls(applyUrls);
        emailRequest.setUnsubscribeURL(getUnsubscribeUrl(emailTokenService,emailRequest,emailMaster,pageSettings,baseUrl));
    }


    private String generateBestPriceUrl(EmailTokenService emailTokenService, EmailRequest emailRequest, EmailMaster emailDetails,
                                        PageSettings pageSettings, String productId, String baseUrl){
        String token = emailTokenService.generateToken(Long.parseLong(emailRequest.getTransactionId()),emailDetails.getHashedEmail(),pageSettings.getBrandId(),
                "bestprice","load", productId, null, pageSettings.getVerticalCode(), null, true);
        return baseUrl + "email/incoming/gateway.json?gaclientid=" + emailRequest.getGaClientID() + "&cid=em:cm:car:200518:car_bp&et_rid=172883275&utm_source=car_quote_bp&utm_medium=email&utm_campaign=car_quote_bp&token=" + token;
    }

    private String getUnsubscribeUrl(EmailTokenService emailTokenService, EmailRequest emailRequest, EmailMaster emailDetails, PageSettings pageSettings, String baseUrl) {
        {
            String token = emailTokenService.generateToken(Long.parseLong(emailRequest.getTransactionId()), emailDetails.getHashedEmail(), pageSettings.getBrandId(),
                    "bestprice", "unsubscribe", null, null, pageSettings.getVerticalCode(), null, true);
            return baseUrl + "unsubscribe.jsp?token=" + token;
        }
    }

    private List<EmailParameters> getSortedTruncatedEmailParameters(EmailRequest emailRequest, Data data) throws DaoException {
        final List<ResultProperty> resultsProperties = emailUtils.getResultPropertiesForTransaction(emailRequest.getTransactionId());

        //Get all product ids
        List<String> productIds = getAllResultProperties(resultsProperties, "productId");

        //For each product get related details.
        List<EmailParameters> emailParameters = productIds.stream().map(productId -> {

                    String premium = getPremiumFromSessionData(data, productId);
                    String providerPhoneNumber = getResultProperty(resultsProperties, "telNo", productId);
                    String quoteUrls = getResultProperty(resultsProperties, "quoteUrl", productId);
                    String openingHour = getResultProperty(resultsProperties, "openingHours", productId);
                    String productDes = getResultProperty(resultsProperties, "productDes", productId);
                    String brandCode = getResultProperty(resultsProperties, "brandCode", productId);
                    String excess = getResultProperty(resultsProperties, "excess/total", productId);
                    String discountOffer = getResultProperty(resultsProperties, "discountOffer", productId);
                    String headlineOffer = getResultProperty(resultsProperties, "headlineOffer", productId);
                    String validDates = getResultProperty(resultsProperties, "validateDate/display", productId);
                    String quoteRef = getResultProperty(resultsProperties, "leadNo", productId);

                    EmailParameters emailParameter = new EmailParameters();
                    emailParameter.setBrandCode(brandCode);
                    emailParameter.setDiscountOffer(discountOffer);
                    emailParameter.setHeadlineOffer(headlineOffer);
                    emailParameter.setPremium(premium);
                    emailParameter.setProductId(productId);
                    emailParameter.setProviderName(productDes);
                    emailParameter.setProviderPhoneNumber(providerPhoneNumber);
                    emailParameter.setQuoteUrl(quoteUrls);
                    emailParameter.setExcess(excess);
                    emailParameter.setOpeningHour(openingHour);
                    emailParameter.setValidDate(validDates);
                    emailParameter.setQuoteRef(quoteRef);
                    return emailParameter;
                }
        ).collect(Collectors.toList());

        Collections.sort(emailParameters);

        // Don't send more than 10 items
        return emailParameters.subList(0, min(emailParameters.size(), 10));
    }

    /**
     * get premium from session data.
     * <p>
     * session data has root, and all child transaction details. There will be multiple result details in case
     * of multiple transactions, and the LAST transaction detail is for the current transaction.
     * <p>
     * <pre>
     * @See test/resources/email/car for sample session data for below cases:
     *
     * CASE-1: User got single quote result e.g., BUDD-05-04
     *  SessionData will have SINGLE value for xPathLumsumtotal xpath.
     *
     * CASE-2: User got quote result, which they edited including the cover type. e.g., BUDD-05-04_TPPD
     *  SessionData will have SINGLE value for xPathLumsumtotal xpath.
     *
     * CASE-3: User got quote result, which they edited but kept the cover type same. e.g., multiple BUDD-05-04
     *  SessionData will have MULTIPLE value for xPathLumsumtotal xpath.
     * </pre>
     *
     * @param sessionDataAsXml
     * @param productId
     * @return String
     * @throws ValidationException when premium is null.
     */
    protected static String getPremiumFromSessionData(Data sessionDataAsXml, String productId) throws ValidationException {

        //productId e.g., BUDD-05-04 or BUDD-05-04_TPPD
        final String xPathProductLumsumtotal = "tempResultDetails/results/" + productId + "/headline/lumpSumTotal";

        String premium;
        try {
            //single transaction (comprehensive or 3rd party)
            premium = EmailUtils.getStringData(sessionDataAsXml, xPathProductLumsumtotal);
        } catch (ClassCastException e) {
            LOGGER.debug("Multiple premiums found in session data for xpath: {}", xPathProductLumsumtotal);
            //multiple transactions for a cover type
            final List<String> premiums = EmailUtils.getListData(sessionDataAsXml, xPathProductLumsumtotal);

            if (premiums.isEmpty()) {
                return null;
            }

            final int lastElementIndex = premiums.size() - 1;
            premium = premiums.get(lastElementIndex);
        }

        if (StringUtils.isBlank(premium)) {
            LOGGER.error("Session data missing premium(s). Session data: {}", sessionDataAsXml.toString());
            throw new ValidationException("Unable to build email parameters. No premium(s) in session data");
        }

        return premium;
    }

}
