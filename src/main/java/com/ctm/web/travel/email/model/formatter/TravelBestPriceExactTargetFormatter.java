package com.ctm.web.travel.email.model.formatter;

import com.ctm.web.core.email.model.ExactTargetEmailModel;
import com.ctm.web.travel.email.model.TravelBestPriceEmailModel;
import com.ctm.web.travel.email.model.TravelBestPriceRanking;
import com.ctm.web.core.email.formatter.ExactTargetFormatter;
import com.ctm.web.core.utils.FormDateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.Date;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class TravelBestPriceExactTargetFormatter extends ExactTargetFormatter<TravelBestPriceEmailModel> {

	private static final Logger LOGGER = LoggerFactory.getLogger(TravelBestPriceExactTargetFormatter.class);

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
		emailModel.setAttribute("CoverLevelType", model.getCoverLevelTabsType());
		emailModel.setAttribute("CoverLevelDesc", model.getCoverLevelTabsDescription());

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
				Date returnDate  = FormDateUtils.parseDateFromForm(date);
				returnFormattedDate = new SimpleDateFormat("EEE, d MMM yyyy").format( returnDate );
			} catch (Exception e) {
				LOGGER.error("Failed to convert date for Exacttarget email {}", kv("date", date), e);
			}
		}

		return returnFormattedDate;
	}

}
