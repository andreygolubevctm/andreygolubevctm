package com.ctm.web.email;

import com.ctm.httpclient.RestSettings;
import com.ctm.web.car.router.CarRouter;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.health.HealthEmailModel;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Observable;
import java.util.stream.IntStream;

import com.ctm.httpclient.Client;
import rx.schedulers.Schedulers;
import sun.rmi.runtime.Log;

/**
 * Created by akhurana on 15/09/17.
 */
@RestController
@RequestMapping("/marketing-automation/")
public class EmailController {

    private MarketingEmailService emailService;
    private final SessionDataService sessionDataService = new SessionDataService();
    @Autowired
    private Client<EmailRequest,EmailResponse> client;
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailController.class);


    @RequestMapping("/sendEmail")
    public void sendEmail(HttpServletRequest request, HttpServletResponse response){
        try {
            SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            EmailRequest emailRequest = new EmailRequest();
            emailRequest.setFirstName(request.getParameter("rank_productName4"));
            emailRequest.setFirstName(request.getParameter("name"));
            emailRequest.setAddress(request.getParameter("address"));

            ArrayList<Data> dataArrayList = sessionData.getTransactionSessionData();
            Data data = dataArrayList.get(0);
            emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
            String transactionId = request.getParameter("transactionId");
            List<String> providerName = buildParameterList(request, "rank_providerName");
            List<String> premiumLabel = buildParameterList(request, "rank_premiumText");
            List<String> premium = buildParameterList(request, "rank_premium");
            List<String> providerCodes = buildParameterList(request, "rank_provider");
            emailRequest.setProvider(providerName);
            emailRequest.setPremiumLabel(premiumLabel);
            emailRequest.setPremium(premium);
            emailRequest.setProviderCode(providerCodes);
            emailRequest.setPremium(premium);
            emailRequest.setPremiumLabel(premiumLabel);
            emailRequest.setProviderCode(providerCodes);
            emailRequest.setTransactionId(transactionId);
            setHealthFields(emailRequest, request);
            setDataFields(emailRequest, data, "health");
            setDataFields(emailRequest, data, "car");
            request.getParameterMap().forEach((s, strings) -> System.out.println("parametersprinted:" + s + ":" + strings));
            EmailResponse emailResponse = client.post(RestSettings.<EmailRequest>builder().request(emailRequest).response(EmailResponse.class)
                    .responseType(MediaType.APPLICATION_JSON).header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .url("https://marketing-automation-service-dev.ctm.cloud.local/marketing-automation/sendEmailRequest")
                    .timeout(30).retryAttempts(2).build()).observeOn(Schedulers.io()).toBlocking().first();
            emailResponse.getSuccess();
        }
        catch(Exception e){
            LOGGER.error("Exception: " + e.getMessage());
        }

    }

    private void setDataFields(EmailRequest emailRequest, Data data, String vertical){
        String email = getParamSafely(data,vertical + "/contactDetails/email");
        String firstName = getParamSafely(data,vertical + "/contactDetails/name");
        String fullAddress = getParamSafely(data,vertical + "/application/address/fullAddress");
        String optIn = getParamSafely(data,vertical+ "/contactDetails/optInEmail");
        String phoneNumber = getParamSafely(data,vertical + "/contactDetails/contactNumber/mobile");
        emailRequest.setPhoneNumber(phoneNumber);
        if(optIn!=null) emailRequest.setOptIn(OptIn.valueOf(optIn));
        emailRequest.setAddress(fullAddress);
        emailRequest.setFirstName(firstName);
        emailRequest.setEmailAddress(email);
    }

    private void setHealthFields(EmailRequest emailRequest, HttpServletRequest request){
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
    }

    private List<String> buildParameterList(HttpServletRequest httpServletRequest, String paramName){
        List params = new ArrayList();
        IntStream.range(0,10).forEach(idx -> params.add(httpServletRequest.getParameter(paramName + idx)));
        return params;
    }

    private String getParamSafely(Data data, String param) {
        try {
            return (String) data.get(param);
        }
        catch(Exception e){
            LOGGER.warn("Field " + param + " not found before sending email");
        }
        return null;
    }

    /**
     * parametersprinted:verificationToken:[Ljava.lang.String;@5b6a53e3
     parametersprinted:rank_rebate8:[Ljava.lang.String;@1919fccf
     parametersprinted:rank_rebate9:[Ljava.lang.String;@65f4bde
     parametersprinted:rank_rebate6:[Ljava.lang.String;@364d2250
     parametersprinted:rank_rebate7:[Ljava.lang.String;@3f319a31
     parametersprinted:rank_productCode0:[Ljava.lang.String;@6998f69c
     parametersprinted:rank_productCode1:[Ljava.lang.String;@156551ca
     parametersprinted:rank_discounted6:[Ljava.lang.String;@4a65ae94
     parametersprinted:rank_productCode2:[Ljava.lang.String;@79b655fb
     parametersprinted:rank_discounted5:[Ljava.lang.String;@57b46047
     parametersprinted:rank_productCode3:[Ljava.lang.String;@6860807a
     parametersprinted:rank_discounted4:[Ljava.lang.String;@f1692ec
     parametersprinted:rank_discounted3:[Ljava.lang.String;@44c40778
     parametersprinted:rank_productCode4:[Ljava.lang.String;@3086f1ff
     parametersprinted:rank_discounted9:[Ljava.lang.String;@5c89c4c5
     parametersprinted:rank_discounted8:[Ljava.lang.String;@67b3bc4a
     parametersprinted:rank_discounted7:[Ljava.lang.String;@3a89803
     parametersprinted:rank_primaryCurrentPHI0:[Ljava.lang.String;@4a69880
     parametersprinted:rank_lhc11:[Ljava.lang.String;@161bdb3d
     parametersprinted:rank_premiumText0:[Ljava.lang.String;@6c306458
     parametersprinted:rootPath:[Ljava.lang.String;@2b1f815d
     parametersprinted:rank_price_shown8:[Ljava.lang.String;@1b4d7e26
     parametersprinted:rank_price_shown9:[Ljava.lang.String;@53478c41
     parametersprinted:transactionId:[Ljava.lang.String;@3cba20d5
     parametersprinted:rank_lhc10:[Ljava.lang.String;@6b785b76
     parametersprinted:rank_price_shown4:[Ljava.lang.String;@1bb4b471
     parametersprinted:rank_rebate4:[Ljava.lang.String;@747e06c2
     parametersprinted:rank_price_shown5:[Ljava.lang.String;@192f3c10
     parametersprinted:rank_rebate5:[Ljava.lang.String;@30a567a8
     parametersprinted:rank_rebate2:[Ljava.lang.String;@e8c5af1
     parametersprinted:rank_price_shown6:[Ljava.lang.String;@a4015f4
     parametersprinted:rank_rebate3:[Ljava.lang.String;@6a6f6710
     parametersprinted:rank_price_shown7:[Ljava.lang.String;@716cc5d2
     parametersprinted:rank_price_shown0:[Ljava.lang.String;@1ddb42dc
     parametersprinted:rank_rebate0:[Ljava.lang.String;@173e0b26
     parametersprinted:rank_price_shown1:[Ljava.lang.String;@6f8a936
     parametersprinted:rank_rebate1:[Ljava.lang.String;@11adbe6e
     parametersprinted:rank_price_shown2:[Ljava.lang.String;@5627d325
     parametersprinted:rank_price_shown3:[Ljava.lang.String;@312785fc
     parametersprinted:rank_price_shown11:[Ljava.lang.String;@72552bf7
     parametersprinted:rank_price_shown10:[Ljava.lang.String;@e77a51d
     parametersprinted:rank_healthSituation0:[Ljava.lang.String;@66a1f10d
     parametersprinted:rank_productId11:[Ljava.lang.String;@6ba48040
     parametersprinted:rank_productId10:[Ljava.lang.String;@30f50450
     parametersprinted:rank_premiumText2:[Ljava.lang.String;@399001e
     parametersprinted:rank_premiumText1:[Ljava.lang.String;@6a59a0f9
     parametersprinted:rank_premiumText4:[Ljava.lang.String;@25308b72
     parametersprinted:rank_price_actual11:[Ljava.lang.String;@3dffcc00
     parametersprinted:rank_premiumText3:[Ljava.lang.String;@762db251
     parametersprinted:rank_price_actual10:[Ljava.lang.String;@51d49a05
     parametersprinted:rank_productId5:[Ljava.lang.String;@709ee056
     parametersprinted:rank_lhc8:[Ljava.lang.String;@3342bd89
     parametersprinted:rank_productId6:[Ljava.lang.String;@28663e8a
     parametersprinted:rank_price_actual9:[Ljava.lang.String;@5d979d31
     parametersprinted:rank_lhc9:[Ljava.lang.String;@5a8c5a85
     parametersprinted:rank_productId3:[Ljava.lang.String;@7c041aa8
     parametersprinted:rank_price_actual8:[Ljava.lang.String;@650ff9cc
     parametersprinted:rank_productId4:[Ljava.lang.String;@4909e49
     parametersprinted:rank_price_actual7:[Ljava.lang.String;@3c70a42c
     parametersprinted:rank_productId1:[Ljava.lang.String;@607d2850
     parametersprinted:rank_lhc4:[Ljava.lang.String;@7aa66c0a
     parametersprinted:rank_productId2:[Ljava.lang.String;@7ac4c7c1
     parametersprinted:rank_lhc5:[Ljava.lang.String;@432c4d71
     parametersprinted:rank_rebate10:[Ljava.lang.String;@4a1ad2ec
     parametersprinted:rank_count:[Ljava.lang.String;@3152199
     parametersprinted:rank_lhc6:[Ljava.lang.String;@5f3304f5
     parametersprinted:rank_rebate11:[Ljava.lang.String;@7e558da7
     parametersprinted:rank_productId0:[Ljava.lang.String;@6244bd33
     parametersprinted:rank_lhc7:[Ljava.lang.String;@4877510b
     parametersprinted:rank_lhc0:[Ljava.lang.String;@fa4f05c
     parametersprinted:rank_price_actual2:[Ljava.lang.String;@5d4e7cba
     parametersprinted:rank_price_actual1:[Ljava.lang.String;@1a24ef05
     parametersprinted:rank_lhc1:[Ljava.lang.String;@68a91a43
     parametersprinted:rank_price_actual0:[Ljava.lang.String;@40a7211a
     parametersprinted:rank_lhc2:[Ljava.lang.String;@6ea22e18
     parametersprinted:rank_lhc3:[Ljava.lang.String;@53c3a80e
     parametersprinted:rank_price_actual6:[Ljava.lang.String;@7398cb37
     parametersprinted:rank_price_actual5:[Ljava.lang.String;@a4e8baf
     parametersprinted:rank_price_actual4:[Ljava.lang.String;@7563a610
     parametersprinted:rank_price_actual3:[Ljava.lang.String;@3b2ef36a
     parametersprinted:rank_excessPerAdmission0:[Ljava.lang.String;@eda564b
     parametersprinted:rank_benefitCodes0:[Ljava.lang.String;@7037a7cc
     parametersprinted:rank_frequency0:[Ljava.lang.String;@180cdcfc
     parametersprinted:rank_productName4:[Ljava.lang.String;@5475c934
     parametersprinted:rank_frequency8:[Ljava.lang.String;@841b5ff
     parametersprinted:rank_productName3:[Ljava.lang.String;@45856afc
     parametersprinted:rank_frequency7:[Ljava.lang.String;@3b10b58c
     parametersprinted:rank_frequency6:[Ljava.lang.String;@4156e7b3
     parametersprinted:rank_frequency5:[Ljava.lang.String;@443d4c2b
     parametersprinted:rank_productName0:[Ljava.lang.String;@2a810cda
     parametersprinted:rank_frequency4:[Ljava.lang.String;@148370d3
     parametersprinted:rank_frequency3:[Ljava.lang.String;@621e668f
     parametersprinted:rank_frequency2:[Ljava.lang.String;@4c6c32f3
     parametersprinted:rank_productName2:[Ljava.lang.String;@6e291078
     parametersprinted:rank_coverType0:[Ljava.lang.String;@6123f086
     parametersprinted:rank_frequency1:[Ljava.lang.String;@7018c833
     parametersprinted:rank_productName1:[Ljava.lang.String;@5d4e9769
     parametersprinted:rank_providerName3:[Ljava.lang.String;@7bc2f668
     parametersprinted:rank_providerName4:[Ljava.lang.String;@51b8e56
     parametersprinted:rank_providerName0:[Ljava.lang.String;@33f49796
     parametersprinted:rank_providerName1:[Ljava.lang.String;@1aa8bb5e
     parametersprinted:rank_providerName2:[Ljava.lang.String;@76356fd5
     parametersprinted:rank_frequency9:[Ljava.lang.String;@2f05367b
     parametersprinted:rank_productId9:[Ljava.lang.String;@38da5c2a
     parametersprinted:rank_productId7:[Ljava.lang.String;@67777224
     parametersprinted:rank_productId8:[Ljava.lang.String;@3ae1f2d8
     parametersprinted:rank_excessPerPolicy0:[Ljava.lang.String;@3c51bd11
     parametersprinted:rankBy:[Ljava.lang.String;@56009dbd
     parametersprinted:rank_excessPerPerson0:[Ljava.lang.String;@a3a330b
     parametersprinted:rank_discounted11:[Ljava.lang.String;@3ff877a6
     parametersprinted:rank_discounted10:[Ljava.lang.String;@e70ec7d
     parametersprinted:rank_specialOffer0:[Ljava.lang.String;@5c4f657b
     parametersprinted:rank_specialOfferTerms0:[Ljava.lang.String;@736a792
     parametersprinted:rank_provider4:[Ljava.lang.String;@7b0fb595
     parametersprinted:rank_discounted2:[Ljava.lang.String;@7215bd8d
     parametersprinted:rank_discounted1:[Ljava.lang.String;@55567a09
     parametersprinted:rank_discounted0:[Ljava.lang.String;@676e5d06
     parametersprinted:rank_coPayment0:[Ljava.lang.String;@614bff63
     parametersprinted:rank_premium4:[Ljava.lang.String;@3eeddf12
     parametersprinted:rank_extrasPdsUrl0:[Ljava.lang.String;@580d6cf4
     parametersprinted:rank_premium1:[Ljava.lang.String;@4d1e8c9e
     parametersprinted:rank_frequency10:[Ljava.lang.String;@7390c2b9
     parametersprinted:rank_premium0:[Ljava.lang.String;@23d58696
     parametersprinted:rank_frequency11:[Ljava.lang.String;@108c34d4
     parametersprinted:rank_premium3:[Ljava.lang.String;@29cf2027
     parametersprinted:rank_premium2:[Ljava.lang.String;@5c3fbaad
     parametersprinted:rank_healthMembership0:[Ljava.lang.String;@53d1768a
     parametersprinted:rank_hospitalPdsUrl0:[Ljava.lang.String;@220ad2b0
     parametersprinted:rank_provider2:[Ljava.lang.String;@721400ce
     parametersprinted:rank_provider3:[Ljava.lang.String;@53df26f3
     parametersprinted:rank_provider0:[Ljava.lang.String;@be27f24
     parametersprinted:rank_provider1:[Ljava.lang.String;@7f09a3ba
     */
}
