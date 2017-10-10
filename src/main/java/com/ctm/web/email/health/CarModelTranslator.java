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
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.email.car.CarEmailModel;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.ws.security.tokenstore.TokenStoreFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

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

    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws RuntimeException {
        List<ResultProperty> resultsProperties = null;
        try {
            resultsProperties = emailUtils.getResultPropertiesForTransaction(emailRequest.getTransactionId());
        } catch (DaoException e) {
            e.printStackTrace();
        }

        List<String> providerNames = getAllResultProperties(resultsProperties, "productDes");
        List<String> providerPhoneNumbers = getAllResultProperties(resultsProperties, "telNo");
        List<String> quoteUrls = getAllResultProperties(resultsProperties, "quoteUrl");
        List<String> openingHours = getAllResultProperties(resultsProperties, "openingHours");
        List<String> productDes = getAllResultProperties(resultsProperties, "productDes");
        List<String> brandCodes = getAllResultProperties(resultsProperties, "brandCode");
        List<String> excesses = getAllResultProperties(resultsProperties, "excess/total");
        List<String> discountOffer = getAllResultProperties(resultsProperties,"discountOffer");
        List<String> headlineOffer = getAllResultProperties(resultsProperties,"headlineOffer");


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
        List<String> validDates = getAllResultProperties(resultsProperties, "validateDate/display");


        /*resultsProperties.forEach(resultProperty -> {
            System.out.println("" + resultProperty.getProperty() + ":" + resultProperty.getValue());
        });*/
        emailRequest.setProviders(providerNames);
        emailRequest.setProviderPhoneNumbers(providerPhoneNumbers);
        emailRequest.setCommencementDate(LocalDate.parse(commencementDate, dateTimeFormatter));
        emailRequest.setAddress(emailUtils.getParamSafely(data, "quote/riskAddress/fullAddress"));
        emailRequest.setApplyUrls(quoteUrls);
        emailRequest.setProductDescriptions(productDes);
        emailRequest.setProviderCodes(brandCodes);
        emailRequest.setFirstName(firstName);
        emailRequest.setLastName(lastName);
        emailRequest.setPhoneNumber(phoneNumber);
        emailRequest.setExcesses(excesses);
        emailRequest.setValidDates(validDates);
        emailRequest.setGaClientID(emailUtils.getParamSafely(data, "/gaclientid"));
        emailRequest.setOptIn(OptIn.valueOf(optIn));
        emailRequest.setProviderSpecialOffers(discountOffer);
        emailRequest.setPremiumLabels(emailUtils.getPremiumLabels(headlineOffer));

        CarEmailModel carEmailModel = new CarEmailModel();
        carEmailModel.setCoverType(typeOfCover);
        carEmailModel.setVehicleMake(make);
        carEmailModel.setVehicleModel(model);
        carEmailModel.setVehicleVariant(vehicleVariant);
        carEmailModel.setVehicleYear(vehicleYear);
        emailRequest.setCarEmailModel(carEmailModel);

        if (!openingHours.isEmpty()) emailRequest.setCallCentreHours(openingHours.get(0));

        String email = getEmail(data);
        if (!StringUtils.isBlank(email)) emailRequest.setEmailAddress(email);
    }

    private List<String> getAllResultProperties(List<ResultProperty> resultProperties, String property) {
        return resultProperties.stream().filter(resultProperty -> resultProperty.getProperty().equals(property))
                .map(resultProperty -> resultProperty.getValue()).collect(Collectors.toList());
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

        String unsubscribeToken = emailTokenService.generateToken(Long.parseLong(emailRequest.getTransactionId()),emailDetails.getHashedEmail(),pageSettings.getBrandId(),
                "bestprice","unsubscribe", null, null, pageSettings.getVerticalCode(), null, true);
        emailTokenService.insertEmailTokenRecord(Long.parseLong(emailRequest.getTransactionId()), emailDetails.getHashedEmail(), pageSettings.getBrandId(),
                "bestprice", "load");

        String baseUrl = pageSettings.getBaseUrl();
        String unsubscribeUrl = baseUrl + "unsubscribe.jsp?token=" + unsubscribeToken;
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }
}
