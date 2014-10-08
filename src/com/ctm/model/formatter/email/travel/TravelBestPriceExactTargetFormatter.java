package com.ctm.model.formatter.email.travel;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import com.ctm.model.email.ExactTargetEmailModel;
import com.ctm.model.email.TravelBestPriceEmailModel;
import com.ctm.model.email.TravelBestPriceRanking;
import com.ctm.model.formatter.email.ExactTargetFormatter;

public class TravelBestPriceExactTargetFormatter extends ExactTargetFormatter<TravelBestPriceEmailModel> {

	private static final Logger logger = Logger.getLogger(TravelBestPriceExactTargetFormatter.class.getName());

	@Override
	protected ExactTargetEmailModel formatXml(TravelBestPriceEmailModel model) {
		emailModel = new ExactTargetEmailModel();
		emailModel.setAttribute("FirstName", model.getFirstName());
		emailModel.setAttribute("LastName",model.getLastName());
		emailModel.setAttribute("ProductLabel", model.getProductLabel());
		emailModel.setAttribute("Brand", model.getBrand());
		emailModel.setAttribute("ProductType", model.getPolicyType());

		String destinations = model.getPolicyType().equals("ST") ? model.getDestinations() : "";
		emailModel.setAttribute("Destinations", destinations);
		emailModel.setAttribute("CompareResultsURL", model.getCompareResultsURL());


		String leaveFormattedDate =  convertDate(model.getStartDate());
		emailModel.setAttribute("TravelStartDate", leaveFormattedDate);

		String returnFormattedDate = convertDate(model.getEndDate());
		emailModel.setAttribute("TravelEndDate", returnFormattedDate);

		emailModel.setAttribute("AdultsTravelling", model.getAdults());
		emailModel.setAttribute("ChildrenTravelling", model.getChildren());
		emailModel.setAttribute("OldestTraveller", model.getOldestAge());
		emailModel.setAttribute("OptIn",parseOptIn(model.getOptIn()));

		int i = 1;
		for(TravelBestPriceRanking rankingDetail : model.getRankings()) {

			emailModel.setAttribute("ApplyURL" + i,  model.getApplyUrl());
			emailModel.setAttribute("CoverType" + i,  rankingDetail.getProductName());
			emailModel.setAttribute("OME" + i,  rankingDetail.getMedical());
			emailModel.setAttribute("CFC" + i,  rankingDetail.getCancellation());
			emailModel.setAttribute("LPE" + i,  rankingDetail.getLuggage());
			emailModel.setAttribute("Premium" + i, rankingDetail.getPremium());
			emailModel.setAttribute("PremiumLabel" + i, "");
			emailModel.setAttribute("Provider" + i, rankingDetail.getProviderName());
			emailModel.setAttribute("Excess" + i, rankingDetail.getExcess());
			emailModel.setAttribute("SmallLogo" + i, "http://image.e.comparethemarket.com.au/lib/fe9b12727466047b76/m/1/travel_" + rankingDetail.getSmallLogo());
			i++;
		}

		emailModel.setAttribute("UnsubscribeURL","");

		return emailModel;
	}

	private String convertDate(String date) {
		String returnFormattedDate = "";

		if (date != null) {
			try {
				Date returnDate = new SimpleDateFormat("dd/MM/yyyy").parse(date);
				returnFormattedDate = new SimpleDateFormat("EEE, d MMM yyyy").format( returnDate );
			} catch (Exception ex) {
				logger.error(ex);
			}
		}

		return returnFormattedDate;
	}

}
