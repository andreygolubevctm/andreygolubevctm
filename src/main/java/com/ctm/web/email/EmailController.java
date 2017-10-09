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
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.health.CarModelTranslator;
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
import java.util.*;

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
    @Autowired
    private CarModelTranslator carModelTranslator;

    private static final String CID = "em:cm:health:300994";
    private static final String ET_RID = "172883275";
    private static final String HEALTH_UTM_SOURCE = "health_quote_";
    private static final String UTM_MEDIUM = "email";
    private static final String CAMPAIGN = "health_quote";
    private static final String EMAIL_TYPE = "bestprice";
    private static final String ACTION_UNSUBSCRIBE = "unsubscribe";

    @RequestMapping("/sendEmail.json")
    public void sendEmail(HttpServletRequest request, HttpServletResponse response){
        try {
            Brand brand = ApplicationService.getBrandFromRequest(request);
            String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
            if (VerticalType.HEALTH != VerticalType.valueOf(verticalCode) && VerticalType.CAR != VerticalType.valueOf(verticalCode))
                return;
            SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
            EmailRequest emailRequest = new EmailRequest();

            //String transactionId = request.getParameter("transactionId");
            Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
            Data data = sessionData.getSessionDataForTransactionId(transactionId);
            emailRequest.setFirstName(request.getParameter("name"));
            emailRequest.setAddress(request.getParameter("address"));
            emailRequest.setTransactionId(transactionId.toString());
            emailRequest.setBrand(brand.getCode());
            List<String> quoteRefs = new ArrayList<>();
            quoteRefs.add(transactionId.toString());
            emailRequest.setQuoteRefs(quoteRefs);
            EmailTranslator emailTranslator = getEmailTranslator(verticalCode);
            emailTranslator.setVerticalSpecificFields(emailRequest, request, data);
            emailTranslator.setUrls(request, emailRequest, data, verticalCode);
            emailRequest.setVertical(verticalCode);
            List<String> premium = emailUtils.buildParameterList(request, "rank_premium");
            emailRequest.setPremiums(premium);
            emailClient.send(emailRequest);
        }
        catch(Exception e){
            LOGGER.error("Exception: " + e.getMessage());
        }
    }

    private EmailTranslator getEmailTranslator(String verticalCode){
        VerticalType verticalType = VerticalType.valueOf(verticalCode);
        if(VerticalType.HEALTH == verticalType){
            return healthModelTranslator;
        }
        else if(VerticalType.CAR == verticalType){
            return carModelTranslator;
        }
        throw new RuntimeException("Vertical not supported");
    }


    /**
     * -22 07:55:06.313 DEBUG 28688 --- [bio-8084-exec-6] c.c.w.c.s.tracking.TrackingKeyService    [2527008::car:bd244df7-04c3-4cce-8af8-c78c266cb1f6] : Generated tracking key. key=dab7ac844c03ee967d834f2098ec725eb62e362c
     brandCode:AI
     discountOffer:Comprehensive car insurance with the option to add extra cover
     excess/total:850
     followupIntended:
     headline/name:Elegant Comprehensive Cover
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:3093440
     openingHours:Monday to Friday (9am - 5pm EST)
     productDes:AI Car Insurance
     productId:AI-01-01
     quoteUrl:https://dev.aiinsurance.com.au/buy/disclosure/3093440
     telNo:1300 284 875
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:AI
     discountOffer:Price shown includes an online discount
     excess/total:850
     followupIntended:
     headline/name:Elegant Plus Comprehensive Cover
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:3093440
     openingHours:Monday to Friday (9am - 5pm EST)
     productDes:AI Car Insurance
     productId:AI-01-03
     quoteUrl:https://dev.aiinsurance.com.au/buy/disclosure/3093440
     telNo:1300 284 875
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:EXDD
     discountOffer:<b>Receive a FREE 7" Android Tablet.                                       Price shown includes a 15% Online Discount.</b>
     excess/total:800
     followupIntended:Y
     headline/name:Dodo Comprehensive
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:W7I221830
     openingHours:Monday - Sunday 8.00am - 11.00pm AEST.
     productDes:Dodo Gold Comprehensive
     productId:EXDD-05-04
     quoteUrl:https://nxq-dodo.disconline.com.au/car/aggregator.jsp?hPID=PCRQSP&hSty=EXDD&afnCde=IHAF&undCpy=05&undPrd=04&ledNo=W7I221830&LinkId=11399&CgpCde=00265&CenCde=10690&vdn=HDAG&addExs=4&ptnId=CTM0000003&srcId=0000000009
     telNo:1800 003 631
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:EXPO
     discountOffer:15% online discount, included automatically in this quote
     excess/total:800
     followupIntended:Y
     headline/name:Australia Post Gold Comprehensive
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:W7I221826
     openingHours:
     productDes:Australia Post Gold Comprehensive
     productId:EXPO-05-16
     quoteUrl:https://nxq-austpost.disconline.com.au/car/aggregator.jsp?hPID=PCRQSP&hSty=EXPO&afnCde=IHAF&undCpy=05&undPrd=16&ledNo=W7I221826&LinkId=10710&CgpCde=00253&CenCde=10569&vdn=1855&addExs=4&ptnId=CTM0000003&srcId=0000000008
     telNo:
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:IBOX
     discountOffer:
     excess/total:0
     followupIntended:
     headline/name:Comprehensive Car Insurance
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:QTE00063048
     openingHours:
     productDes:Comprehensive Car Insurance
     productId:IB-01-01
     quoteUrl:http://quote-ctm-uat.insurancebox.com.au/Qualification/GetQuote?quoteId=QTE00063048
     telNo:
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:REIN
     discountOffer:This price includes a discount of up to 10%.
     excess/total:800
     followupIntended:
     headline/name:Real Pay As You Drive
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:101493735
     openingHours:Mon – Fri (8am – 7pm EST) and Sat (9am-5pm EST)
     productDes:Real Pay As You Drive
     productId:REIN-01-01
     quoteUrl:https://quotesit.realinsurance.com.au/car/ls/comparethemarket?t=4o2hhcSPmcq2a%2fGZ3%2ftYQM4B9wMXcQeunYgfdC5JmIA8%3dY&n=101493735&p=PAYD&utm_source=comparethemarket&utm_medium=referral&utm_campaign=websale
     telNo:1300 301 918
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:REIN
     discountOffer:This price includes a discount of up to 10%.
     excess/total:800
     followupIntended:
     headline/name:Comprehensive Car Insurance
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:101493735
     openingHours:Mon – Fri (8am – 7pm EST) and Sat (9am-5pm EST)
     productDes:Comprehensive Car Insurance
     productId:REIN-01-02
     quoteUrl:https://quotesit.realinsurance.com.au/car/ls/comparethemarket?t=4o2hhcSPmcq2a%2fGZ3%2ftYQM4B9wMXcQeunYgfdC5JmIA8%3dY&n=101493735&p=COMP&utm_source=comparethemarket&utm_medium=referral&utm_campaign=websale
     telNo:1300 301 918
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:VIRG
     discountOffer:<b>Receive 10,000 Velocity Frequent Flyer Points, plus price includes 15%  discount.</b>
     excess/total:800
     followupIntended:Y
     headline/name:Virgin Car Insurance Price Saver
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:W7I221825
     openingHours:Monday - Friday 8:00am - 8:00pm EST, Sat 8:00am - 5:00pm EST
     productDes:Virgin Car Insurance Price Saver
     productId:VIRG-05-17
     quoteUrl:https://nxq-virgin.disconline.com.au/car/aggregator.jsp?hPID=PCRQSP&hSty=VIRG&afnCde=VIRG&undCpy=05&undPrd=17&ledNo=W7I221825&LinkId=9601&CgpCde=&CenCde=&vdn=1740&addExs=4&ptnId=CTM0000003&srcId=0000000004&hSty=VIRG
     telNo:1800 010 414
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:WOOL
     discountOffer:This price includes a discount of up to 10% when you purchase a policy online.
     excess/total:800
     followupIntended:
     headline/name:Woolworths Drive Less Pay Less
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:101320384
     openingHours:Mon – Fri (8am – 8pm EST) and Sat (9am-5pm EST)
     productDes:Woolworths Drive Less Pay Less
     productId:WOOL-01-01
     quoteUrl:https://wowcarsit.realinsurance.com.au/car/ls/comparethemarket?t=8LRJqlOyMdT4YvHlSfZpgqUEO0IFrja2n5Lg1wIrwXUc%3dO&n=101320384&p=PAYD&utm_source=comparethemarket&utm_medium=referral&utm_campaign=websale
     telNo:1300 782 182
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22
     brandCode:WOOL
     discountOffer:If you’re 25 or over and our quote is not cheaper than your current renewal notice we’ll beat it!
     excess/total:800
     followupIntended:
     headline/name:Woolworths Comprehensive
     leadfeedinfo:Compare TheMarket||0755254545||MAZD12EP||QLD
     leadNo:101320384
     openingHours:Mon – Fri (8am – 8pm EST) and Sat (9am-5pm EST)
     productDes:Woolworths Comprehensive
     productId:WOOL-01-02
     quoteUrl:https://wowcarsit.realinsurance.com.au/car/ls/comparethemarket?t=8LRJqlOyMdT4YvHlSfZpgqUEO0IFrja2n5Lg1wIrwXUc%3dO&n=101320384&p=COMP&utm_source=comparethemarket&utm_medium=referral&utm_campaign=websale
     telNo:1300 782 182
     validateDate/display:22 October 2017
     validateDate/normal:2017-10-22

     */

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
