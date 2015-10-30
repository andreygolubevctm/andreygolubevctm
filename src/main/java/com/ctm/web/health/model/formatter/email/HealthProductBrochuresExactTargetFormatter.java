package com.ctm.web.health.model.formatter.email;

import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.model.email.HealthProductBrochuresEmailModel;
import com.ctm.web.core.email.formatter.ExactTargetFormatter;

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

		return emailModel;
	}

}
