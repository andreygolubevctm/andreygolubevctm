package com.ctm.web.health.email.formatter;

import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.email.model.HealthProductBrochuresEmailModel;

public class HealthProductBrochuresExactTargetFormatter extends ExactTargetFormatter<HealthProductBrochuresEmailModel> {

	@Override
	protected ExactTargetEmailModel formatXml(HealthProductBrochuresEmailModel model) {
		emailModel = new ExactTargetEmailModel();
		emailModel.setAttribute("Brand",model.getBrand());
		emailModel.setAttribute("QuoteReference", String.valueOf(model.getTransactionId()));
		emailModel.setAttribute("PhoneNumber", model.getPhoneNumber());
		emailModel.setAttribute("ApplyURL1", model.getApplyURL());

		emailModel.setAttribute("CallcentreHours", model.getCallcentreHours());
		emailModel.setAttribute("CoverType1", model.getProductName());
		emailModel.setAttribute("FirstName", model.getFirstName());
		emailModel.setAttribute("LastName",model.getLastName());

		emailModel.setAttribute("OptIn",parseOptIn(model.getOptIn()));
		emailModel.setAttribute("PhoneNumber1", model.getPhoneNumber());
		emailModel.setAttribute("Premium1", model.getPremium());

		emailModel.setAttribute("PremiumFrequency", model.getPremiumFrequency());

		emailModel.setAttribute("PremiumLabel1", model.getPremiumText());

		emailModel.setAttribute("Provider1", model.getProvider());
		emailModel.setAttribute("SmallLogo1", IMAGE_BASE_URL + "health_" + model.getSmallLogo());

		emailModel.setAttribute("HospitalPDSUrl", model.getHospitalPDSUrl());
		emailModel.setAttribute("ExtrasPDSUrl", model.getExtrasPDSUrl());

		model.getHealthSituation().ifPresent(v -> emailModel.setAttribute("HealthSituation", v));
		model.getPrimaryCurrentPHI().ifPresent(v -> emailModel.setAttribute("PrimaryCurrentPHI", v));
		model.getCoverType().ifPresent(v -> emailModel.setAttribute("CoverType", v));
		model.getBenefitCodes().ifPresent(v -> emailModel.setAttribute("BenefitCodes", v));
		model.getSpecialOffer().ifPresent(v -> emailModel.setAttribute("P1SpecialOffer", v));
		model.getSpecialOfferTerms().ifPresent(v -> emailModel.setAttribute("P1SpecialOfferTerms", v));
		model.getExcessPerAdmission().ifPresent(v -> emailModel.setAttribute("P1ExcessPerAdmission", v));
		model.getExcessPerPerson().ifPresent(v -> emailModel.setAttribute("P1ExcessPerPerson", v));
		model.getExcessPerPolicy().ifPresent(v -> emailModel.setAttribute("P1ExcessPerPolicy", v));
		model.getCoPayment().ifPresent(v -> emailModel.setAttribute("P1Copayment", v));

		return emailModel;
	}

}
