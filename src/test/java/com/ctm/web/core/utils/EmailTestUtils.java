package com.ctm.web.core.utils;

import com.ctm.web.health.email.model.HealthBestPriceEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceRanking;

import java.util.ArrayList;
import java.util.List;

public class EmailTestUtils {

	public static final String productName1 = "Auf Hospital And Mid Range Extras";
	public static final String productName2 = "HCF Better Hospital & Lots Of Extras 50%";
	public static final String productName3 = "NIB Hospital And Mid Range Extras";
	public static final String productName4 = "GMH Hospital And Mid Range Extras";
	public static final String productName5 = "GMF Hospital And Mid Range Extras";
	public static final String hospitalPdsUrl1 = "health_brochure.jsp?pdf=/AUF/active_hospital.pdf";
	public static final String extrasPdsUrl1 = "health_brochure.jsp?pdf=/AUF/active_extras.pdf";
	public static final String specialOffer1 = "This is a special offer";
	public static final String specialOfferTerms1 = "This is the terms";
	public static final String premiumTotal1 = "$300.00";
	public static final String excessPerAdmission1 = "$100.00";
	public static final String excessPerPolicy1 = "$300.00";
	public static final String excessPerPerson1 = "$30.00";
	public static final String coPayment1 = "No Copayment";
	public static final String healthMembership = "Family";
	public static final String coverLevel = "Basic";
	public static final String healthSituation = "Specific health need";
	public static final String benefitCodes = "PrHospital,Cardiac,DentalGeneral,Optical,Podiatry,Physiotherapy,Chiropractic,Massage";
	public static final String coverType = "Combined";
	public static final String primaryCurrentPHI = "N";
	public static String brand = "ctm";
	public static String applyURL ="url1";
	public static String phoneNumber = "1800 77 77 12";
	public static String premium1 = "$195.95";
	public static String premium2 = "$196.95";
	public static String premium3 = "$197.95";
	public static String premium4 = "$198.95";
	public static String premium5 = "$198.95";
	public static String premiumLabel1 = "+ $26.48 LHC inc $0.00 Government Rebate";
	public static String premiumLabel2 = "+ $27.48 LHC inc $0.00 Government Rebate";
	public static String premiumLabel3 = "+ $28.48 LHC inc $0.00 Government Rebate";
	public static String premiumLabel4 = "+ $29.48 LHC inc $0.00 Government Rebate";
	public static String premiumLabel5 = "+ $30.48 LHC inc $0.00 Government Rebate";

	public static String provider1 = "AUF";
	public static String provider2 = "HCF";
	public static String provider3 = "NIB";
	public static String provider4 = "GMH";
	public static String provider5 = "GMF";

	public static String provider1ImageUrl =  "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_" + provider1 + ".png";
	public static String provider2ImageUrl =  "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_" + provider2 + ".png";
	public static String provider3ImageUrl =  "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_" + provider3 + ".png";
	public static String provider4ImageUrl =  "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_" + provider4 + ".png";
	public static String provider5ImageUrl =  "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/health_" + provider5 + ".png";



	public static String callcentreHours = "Mon - Fri 8:30am - 8pm&lt;br&gt;Sat 10am - 4pm";
	public static String coverType1 = "StarterPak";
	public static String emailAddress= "unittest@test.com.au";
	public static String firstName = "Guybrush";
	public static boolean optIn = false;
	public static String optInVar = "N";
	public static String premiumFrequency = "monthly";
	public static long quoteReference = 2183047;
	public static String unsubscribeURL = "http://localhost:8080/ctm/unsubscribe.jsp?unsubscribe_email=a5161c8d93c5286f695c08551c9d743b5f067801&vertical=health";


	public static String productName = "productName";

	public static HealthBestPriceEmailModel newBestPriceEmailModel(){
		HealthBestPriceEmailModel model = new HealthBestPriceEmailModel();

		List<HealthBestPriceRanking> productInformation = new ArrayList<>() ;

		HealthBestPriceRanking p1 = new HealthBestPriceRanking();
		HealthBestPriceRanking p2 = new HealthBestPriceRanking();
		HealthBestPriceRanking p3 = new HealthBestPriceRanking();
		HealthBestPriceRanking p4 = new HealthBestPriceRanking();
		HealthBestPriceRanking p5 = new HealthBestPriceRanking();

		p1.setSmallLogo(provider1 + ".png");
		p2.setSmallLogo(provider2 + ".png");
		p3.setSmallLogo(provider3 + ".png");
		p4.setSmallLogo(provider4 + ".png");
		p5.setSmallLogo(provider5 + ".png");

		p1.setPremium(premium1);
		p2.setPremium(premium2);
		p3.setPremium(premium3);
		p4.setPremium(premium4);
		p5.setPremium(premium5);


		p1.setPremiumText(premiumLabel1);
		p2.setPremiumText(premiumLabel2);
		p3.setPremiumText(premiumLabel3);
		p4.setPremiumText(premiumLabel4);
		p5.setPremiumText( premiumLabel5);


		p1.setProviderName(provider1);
		p2.setProviderName(provider2);
		p3.setProviderName(provider3);
		p4.setProviderName(provider4);
		p5.setProviderName(provider5);

		productInformation.add(p1 );
		productInformation.add(p2);
		productInformation.add(p3);
		productInformation.add(p4);
		productInformation.add(p5);


		model.setBrand(brand);
		model.setCallcentreHours(callcentreHours);
		model.setCoverType1(coverType1);
		model.setEmailAddress(emailAddress);
		model.setFirstName(firstName);
		model.setOptIn(optIn);
		model.setPhoneNumber(phoneNumber);
		model.setPremiumFrequency(premiumFrequency);
		model.setRankings(productInformation);
		model.setTransactionId(quoteReference);
		model.setUnsubscribeURL(unsubscribeURL);
		model.setApplyUrl(applyURL);

		model.setCustomerKey("QA_CTM_Health_Quote_Trans_TS_key");
		return model;

	}

	public static HealthBestPriceEmailModel newBestPriceEmailModelV2(){
		HealthBestPriceEmailModel model = new HealthBestPriceEmailModel();

		List<HealthBestPriceRanking> productInformation = new ArrayList<>() ;

		HealthBestPriceRanking p1 = new HealthBestPriceRanking();
		HealthBestPriceRanking p2 = new HealthBestPriceRanking();
		HealthBestPriceRanking p3 = new HealthBestPriceRanking();
		HealthBestPriceRanking p4 = new HealthBestPriceRanking();
		HealthBestPriceRanking p5 = new HealthBestPriceRanking();

		p1.setSmallLogo(provider1 + ".png");
		p2.setSmallLogo(provider2 + ".png");
		p3.setSmallLogo(provider3 + ".png");
		p4.setSmallLogo(provider4 + ".png");
		p5.setSmallLogo(provider5 + ".png");

		p1.setPremium(premium1);
		p2.setPremium(premium2);
		p3.setPremium(premium3);
		p4.setPremium(premium4);
		p5.setPremium(premium5);


		p1.setPremiumText(premiumLabel1);
		p2.setPremiumText(premiumLabel2);
		p3.setPremiumText(premiumLabel3);
		p4.setPremiumText(premiumLabel4);
		p5.setPremiumText( premiumLabel5);


		p1.setProviderName(provider1);
		p2.setProviderName(provider2);
		p3.setProviderName(provider3);
		p4.setProviderName(provider4);
		p5.setProviderName(provider5);

		p1.setProductName(productName1);
		p2.setProductName(productName2);
		p3.setProductName(productName3);
		p4.setProductName(productName4);
		p5.setProductName(productName5);

		p1.setHospitalPdsUrl(hospitalPdsUrl1);
		p1.setExtrasPdsUrl(extrasPdsUrl1);
		p1.setSpecialOffer(specialOffer1);
		p1.setSpecialOfferTerms(specialOfferTerms1);
		p1.setPremiumTotal(premiumTotal1);
		p1.setExcessPerAdmission(excessPerAdmission1);
		p1.setExcessPerPolicy(excessPerPolicy1);
		p1.setExcessPerPerson(excessPerPerson1);
		p1.setCoPayment(coPayment1);

		productInformation.add(p1);
		productInformation.add(p2);
		productInformation.add(p3);
		productInformation.add(p4);
		productInformation.add(p5);


		model.setBrand(brand);
		model.setCallcentreHours(callcentreHours);
		model.setCoverType1(coverType1);
		model.setEmailAddress(emailAddress);
		model.setFirstName(firstName);
		model.setOptIn(optIn);
		model.setPhoneNumber(phoneNumber);
		model.setPremiumFrequency(premiumFrequency);
		model.setRankings(productInformation);
		model.setTransactionId(quoteReference);
		model.setUnsubscribeURL(unsubscribeURL);
		model.setApplyUrl(applyURL);

		model.setHealthMembership(healthMembership);
		model.setCoverLevel(coverLevel);
		model.setHealthSituation(healthSituation);
		model.setBenefitCodes(benefitCodes);
		model.setCoverType(coverType);
		model.setPrimaryCurrentPHI(primaryCurrentPHI);

		model.setCustomerKey("QA_CTM_Health_Quote_Trans_TS_key");
		return model;

	}

}
