package com.ctm.web.email.health;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class HealthModelTranslator {

    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.HEALTH.name().toLowerCase();
    private static final VerticalType verticalCode = VerticalType.HEALTH;

    public void setHealthFields(EmailRequest emailRequest, HttpServletRequest request, Data data){
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName");
        List<String> premiumLabel = emailUtils.buildParameterList(request, "rank_premiumText");
        List<String> premium = emailUtils.buildParameterList(request, "rank_premium");
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider");
        String gaclientId = emailUtils.getParamFromXml(dataXml, "gaclientid", "/health/");
        emailRequest.setVertical(vertical);
        emailRequest.setProviders(providerName);
        emailRequest.setPremiumLabels(premiumLabel);
        emailRequest.setProviderCodes(providerCodes);
        emailRequest.setPremiums(premium);
        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
        emailRequest.setCoverType(request.getParameter("rank_coverType0"));
        emailRequest.setGaClientID(gaclientId);

        String benefitCodes = request.getParameter("rank_benefitCodes0");
        String extrasPdsUrl = request.getParameter("rank_extrasPdsUrl0");
        String coPayment =  request.getParameter("rank_coPayment0");
        String excessPerPerson = request.getParameter("rank_excessPerPerson0");
        String excessPerPolicy = request.getParameter("rank_excessPerPolicy0");
        String excessPerAdmission = request.getParameter("rank_excessPerAdmission0");
        String hospitalPdsUrl = request.getParameter("rank_hospitalPdsUrl0");
        String healthSituation = request.getParameter("rank_healthSituation0");

        String dataXml = request.getParameter("data");

        HealthEmailModel healthEmailModel = new HealthEmailModel();
        healthEmailModel.setBenefitCodes(benefitCodes);
        healthEmailModel.setCurrentCover(emailUtils.getParamSafely(data,vertical + "/healthCover/primary/cover"));
        healthEmailModel.setNumberOfChildren(emailUtils.getParamSafely(data,vertical + "/healthCover/dependants"));
        healthEmailModel.setProvider1Copayment(coPayment);
        healthEmailModel.setProvider1ExcessPerAdmission(excessPerAdmission);
        healthEmailModel.setProvider1ExcessPerPolicy(excessPerPolicy);
        healthEmailModel.setProvider1ExtrasPdsUrl(extrasPdsUrl);
        healthEmailModel.setProvider1HospitalPdsUrl(hospitalPdsUrl);

        // Not sure why this is here twice.
        // Not sure why this is here twice.
        // Not sure why this is here twice.
        // Not sure why this is here twice.
        healthEmailModel.setSituationType(healthSituation);
        healthEmailModel.setSituationType(emailUtils.getParamSafely(data,vertical + "/situation/healthCvr"));
        // Not sure why this is here twice.
        // Not sure why this is here twice.
        // Not sure why this is here twice.
        // Not sure why this is here twice.

        emailRequest.setHealthEmailModel(healthEmailModel);
        setDataFields(emailRequest, data);
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
