package com.ctm.web.email.health;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class HealthModelTranslator {

    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.HEALTH.name().toLowerCase();
    private static final VerticalType verticalCode = VerticalType.HEALTH;

    public void setHealthFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws DaoException, ConfigSettingException {
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName");
        List<String> premiumLabel = emailUtils.buildParameterList(request, "rank_premiumText");
        List<String> premium = emailUtils.buildParameterList(request, "rank_premium");
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider");
        emailRequest.setProviders(providerName);
        emailRequest.setPremiumLabels(premiumLabel);
        emailRequest.setProviderCodes(providerCodes);
        emailRequest.setPremiums(premium);
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
        String healthSituation = request.getParameter("rank_healthSituation0");
        String specialOffer = request.getParameter("rank_specialOffer0");
        List<String> specialOffers = new ArrayList<>();
        specialOffers.add(specialOffer);
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
        healthEmailModel.setSituationType(healthSituation);
        healthEmailModel.setNumberOfChildren(emailUtils.getParamSafely(data,vertical + "/healthCover/dependants"));
        healthEmailModel.setSituationType(emailUtils.getParamSafely(data,vertical + "/situation/healthCvr"));
        healthEmailModel.setCurrentCover(emailUtils.getParamSafely(data,vertical + "/healthCover/primary/cover"));
        emailRequest.setGaClientID(gaclientId);
        emailRequest.setHealthEmailModel(healthEmailModel);
        emailRequest.setCallCentreHours(getCallCentreNumber(request));
        List<String> quoteRefs = new ArrayList<>();
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        IntStream.range(1,10).forEach(value -> quoteRefs.add(transactionId.toString()));
        emailRequest.setQuoteRefs(quoteRefs);
        emailRequest.setProviderSpecialOffers(specialOffers);
        setDataFields(emailRequest, data);
    }
    private String getCallCentreNumber(HttpServletRequest request) throws DaoException, ConfigSettingException {
        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        ContentDao contentDao = new ContentDao(pageSettings.getBrandId(), pageSettings.getVertical().getId());
        Content content = contentDao.getByKey("callCentreNumber", ApplicationService.getServerDate(), false);
        return content != null ? content.getContentValue() : "";
    }


    private void setDataFields(EmailRequest emailRequest, Data data){
        String email = getEmail(emailRequest,data);
        String firstName = emailUtils.getParamSafely(data,vertical + "/contactDetails/name");
        String fullAddress = emailUtils.getParamSafely(data,vertical + "/application/address/fullAddress");
        emailRequest.setOptIn(getOptIn(emailRequest, data));
        String phoneNumber = emailUtils.getParamSafely(data,vertical + "/contactDetails/contactNumber/mobile");
        emailRequest.setPhoneNumber(phoneNumber);

        emailRequest.setAddress(fullAddress);
        emailRequest.setFirstName(firstName);
        emailRequest.setEmailAddress(email);
    }

    public String getEmail(EmailRequest emailRequest, Data data){
        return emailUtils.getParamSafely(data,vertical + "/contactDetails/email");
    }

    public OptIn getOptIn(EmailRequest emailRequest,Data data){
        String optIn = emailUtils.getParamSafely(data,vertical + "/contactDetails/optInEmail");
        if(optIn!=null){
            return OptIn.valueOf(optIn);
        }
        return OptIn.N;
    }
}
