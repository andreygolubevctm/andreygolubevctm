package com.ctm.web.health.email.formatter;

import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceRanking;

public class HealthBestPriceExactTargetFormatter extends ExactTargetFormatter<HealthBestPriceEmailModel> {

	@Override
	protected ExactTargetEmailModel formatXml(HealthBestPriceEmailModel model) {
		emailModel = new ExactTargetEmailModel();
		emailModel.setAttribute("FirstName", model.getFirstName());
		emailModel.setAttribute("LastName","");
		emailModel.setAttribute("OptIn",parseOptIn(model.getOptIn()));
		emailModel.setAttribute("Brand",model.getBrand());
		emailModel.setAttribute("QuoteReference", String.valueOf(model.getQuoteReference()));
		emailModel.setAttribute("PhoneNumber", model.getPhoneNumber());
		model.getHealthMembership().ifPresent(v -> emailModel.setAttribute("HealthMembership", v));
		model.getCoverLevel().ifPresent(v -> emailModel.setAttribute("CoverLevel", v));
		model.getHealthSituation().ifPresent(v -> emailModel.setAttribute("HealthSituation", v));
		model.getBenefitCodes().ifPresent(v -> emailModel.setAttribute("BenefitCodes", v));
		model.getCoverType().ifPresent(v -> emailModel.setAttribute("CoverType", v));
		model.getPrimaryCurrentPHI().ifPresent(v -> emailModel.setAttribute("PrimaryCurrentPHI", v));
		emailModel.setAttribute("LoadQuoteUrl",  model.getApplyUrl());

		int i = 1;
		for(HealthBestPriceRanking rankingDetail : model.getRankings()) {
			final int index = i;

			emailModel.setAttribute("ApplyURL" + index,  model.getApplyUrl());
			emailModel.setAttribute("PhoneNumber" + index, model.getPhoneNumber());
			emailModel.setAttribute("Premium" + index, rankingDetail.getPremium());
			emailModel.setAttribute("PremiumLabel" + index, rankingDetail.getPremiumText());
			emailModel.setAttribute("Provider" + index, rankingDetail.getProviderName());
			emailModel.setAttribute("SmallLogo" + index, IMAGE_BASE_URL + "health_" + rankingDetail.getSmallLogo());

			emailModel.setAttribute("P" + index + "ProductName", rankingDetail.getProductName());
			rankingDetail.getHospitalPdsUrl().ifPresent(v -> emailModel.setAttribute("P" + index + "HospitalPdsUrl", v));
			rankingDetail.getExtrasPdsUrl().ifPresent(v -> emailModel.setAttribute("P" + index + "ExtrasPdsUrl", v));
			rankingDetail.getSpecialOffer().ifPresent(v -> emailModel.setAttribute("P" + index + "SpecialOffer", v));
			rankingDetail.getSpecialOfferTerms().ifPresent(v -> emailModel.setAttribute("P" + index + "SpecialOfferTerms", v));
			rankingDetail.getPremiumTotal().ifPresent(v -> emailModel.setAttribute("P" + index + "PremiumTotal", v));
			rankingDetail.getExcessPerAdmission().ifPresent(v -> emailModel.setAttribute("P" + index + "ExcessPerAdmission", v));
			rankingDetail.getExcessPerPerson().ifPresent(v -> emailModel.setAttribute("P" + index + "ExcessPerPerson", v));
			rankingDetail.getExcessPerPolicy().ifPresent(v -> emailModel.setAttribute("P" + index + "ExcessPerPolicy", v));
			rankingDetail.getCoPayment().ifPresent(v -> emailModel.setAttribute("P" + index + "Copayment", v));

			i++;
		}

		emailModel.setAttribute("CallcentreHours",model.getCallcentreHours());
		emailModel.setAttribute("CoverType1",model.getCoverType1());
		emailModel.setAttribute("PremiumFrequency",model.getPremiumFrequency());

		return emailModel;
	}

}
