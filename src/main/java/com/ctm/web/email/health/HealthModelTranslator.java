package com.ctm.web.email.health;

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

    public void setHealthFields(EmailRequest emailRequest, HttpServletRequest request, Data data){
        List<String> providerName = emailUtils.buildParameterList(request, "rank_providerName");
        List<String> premiumLabel = emailUtils.buildParameterList(request, "rank_premiumText");
        List<String> premium = emailUtils.buildParameterList(request, "rank_premium");
        List<String> providerCodes = emailUtils.buildParameterList(request, "rank_provider");
        emailRequest.setProvider(providerName);
        emailRequest.setPremiumLabel(premiumLabel);
        emailRequest.setProviderCode(providerCodes);
        emailRequest.setPremium(premium);
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
        String coverType = request.getParameter("rank_coverType0");

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
        emailRequest.setHealthEmailModel(healthEmailModel);
        setDataFields(emailRequest, data, "health");
    }

    private void setDataFields(EmailRequest emailRequest, Data data, String vertical){
        String email = emailUtils.getParamSafely(data,vertical + "/contactDetails/email");
        String firstName = emailUtils.getParamSafely(data,vertical + "/contactDetails/name");
        String fullAddress = emailUtils.getParamSafely(data,vertical + "/application/address/fullAddress");
        String optIn = emailUtils.getParamSafely(data,vertical+ "/contactDetails/optInEmail");
        String phoneNumber = emailUtils.getParamSafely(data,vertical + "/contactDetails/contactNumber/mobile");
        emailRequest.setPhoneNumber(phoneNumber);
        if(optIn!=null) emailRequest.setOptIn(OptIn.valueOf(optIn));
        emailRequest.setAddress(fullAddress);
        emailRequest.setFirstName(firstName);
        emailRequest.setEmailAddress(email);
    }
}
