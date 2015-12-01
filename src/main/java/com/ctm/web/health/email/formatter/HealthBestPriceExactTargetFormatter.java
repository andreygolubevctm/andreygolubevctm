package com.ctm.web.health.email.formatter;

import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.email.model.BestPriceRanking;
import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceEmailModel;

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

		int i = 1;
		for(BestPriceRanking rankingDetail : model.getRankings()) {

			emailModel.setAttribute("ApplyURL" + i,  model.getApplyUrl());
			emailModel.setAttribute("PhoneNumber" + i, model.getPhoneNumber());
			emailModel.setAttribute("Premium" + i, rankingDetail.getPremium());
			emailModel.setAttribute("PremiumLabel" + i, rankingDetail.getPremiumText());
			emailModel.setAttribute("Provider" + i, rankingDetail.getProviderName());
			emailModel.setAttribute("SmallLogo" + i, IMAGE_BASE_URL + "health_" + rankingDetail.getSmallLogo());
			i++;
		}

		emailModel.setAttribute("CallcentreHours",model.getCallcentreHours());
		emailModel.setAttribute("CoverType1",model.getCoverType1());
		emailModel.setAttribute("PremiumFrequency",model.getPremiumFrequency());

		return emailModel;
	}

}