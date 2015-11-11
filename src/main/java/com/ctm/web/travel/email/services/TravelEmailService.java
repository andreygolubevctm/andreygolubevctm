package com.ctm.web.travel.email.services;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.CountryMappingDao;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.*;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.CountryMapping;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.travel.email.model.TravelBestPriceEmailModel;
import com.ctm.web.travel.email.model.TravelBestPriceRanking;
import com.ctm.web.travel.email.model.formatter.TravelBestPriceExactTargetFormatter;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class TravelEmailService extends EmailServiceHandler implements BestPriceEmailHandler {

	private static final String VERTICAL = VerticalType.TRAVEL.getCode();

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private final EmailUrlService urlService;
	private Data data;

	public TravelEmailService(PageSettings pageSettings, EmailMode emailMode, EmailDetailsService emailDetailsService, EmailUrlService urlService, Data data) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
		this.urlService = urlService;
		this.data = data;
	}

	@Override
	public String send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				return sendBestPriceEmail(request, emailAddress,transactionId);
			default:
				break;
		}
		return "";
	}

	@Override
	public String sendBestPriceEmail(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);

		splitTestEnabledKey = BestPriceEmailHandler.SPLIT_TESTING_ENABLED;

		ExactTargetEmailSender<TravelBestPriceEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings, transactionId);

		try {
			EmailMaster emailDetails = new EmailMaster();
			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setSource("QUOTE");
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE",  request.getRemoteAddr());

			if(!isTestEmailAddress) {
				return emailSender.sendToExactTarget(new TravelBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId));
			} else {
				return "";
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  transactionId  ,  e);
		}
	}

	private TravelBestPriceEmailModel buildBestPriceEmailModel(EmailMaster emailDetails, long transactionId) throws SendEmailException {
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		TravelBestPriceEmailModel emailModel = new TravelBestPriceEmailModel();
		buildEmailModel(emailDetails, emailModel);

		try {
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setLastName(emailDetails.getLastName());
			emailModel.setProductLabel("Travel Insurance");
			emailModel.setAdults((String) data.get("travel/adults"));
			emailModel.setChildren((String) data.get("travel/children"));
			emailModel.setStartDate((String) data.get("travel/dates/fromDate"));
			emailModel.setEndDate((String) data.get("travel/dates/toDate"));
			emailModel.setAdult1DOB((String) data.get("travel/adults/dob/adult1"));

			String adult2DOB = (String) data.get("travel/adults/dob/adult2");

			if (adult2DOB != null && !adult2DOB.isEmpty()) {
				emailModel.setAdult2DOB(adult2DOB);
			}

			// default to standard if travel/coverLevelTab xpath is not found
			String coverLevelTab = (String) data.get("travel/coverLevelTab");
			coverLevelTab = (coverLevelTab == null || coverLevelTab.equals(""))  ? "standard" : coverLevelTab;
			emailModel.setCoverLevelTabsType(coverLevelTab);

			Date serverDate = ApplicationService.getApplicationDate(null);
			Content content = ContentService.getInstance().getContent("CoverLevelTabKeys", pageSettings.getBrandId(), 2, serverDate, true);
			emailModel.setCoverLevelTabsDescription(content.getSupplementaryValueByKey(coverLevelTab+"EDMVar"));

			emailModel.setOptIn((boolean) (data.get("travel/marketing") != null && data.get("travel/marketing").equals("Y")));

			String price_presentation_url = pageSettings.getBaseUrl() + "travel_quote.jsp?action=load&type=bestprice&id=" + transactionId + "&hash=" + emailDetails.getHashedEmail() + "&vertical=travel&type="+(String) data.get("travel/policyType");
			emailModel.setCompareResultsURL(price_presentation_url);


			String pt = (String) data.get("travel/policyType");
			emailModel.setPolicyType(pt.equals("S") ? "ST" : "AMT");
			emailModel.setDuration((String) data.get("travel/soapDuration"));

			emailModel.setDestinations(getDestinations((String) data.get("travel/destination")));

			setupRankingDetails(emailModel, transactionId);
			emailModel.setTransactionId(transactionId);
			emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailDetails));
			emailModel.setApplyUrl(price_presentation_url);
			} catch (DaoException|EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}
		String splitTest = (String) data.get("travel/bestPriceSplitTest");
		String mailingKey;
		String mailingKeyVariation;
		if(optedIn) {
			mailingKey = BestPriceEmailHandler.OPT_IN_MAILING_NAME;
			mailingKeyVariation = BestPriceEmailHandler.OPT_IN_MAILING_NAME_VARIATION;
		} else {
			mailingKey = BestPriceEmailHandler.MAILING_NAME_KEY;
			mailingKeyVariation = BestPriceEmailHandler.MAILING_NAME_KEY_VARIATION;
		}
		setCustomerKey(emailModel, getSplitTestMailingName(mailingKey,  mailingKeyVariation, splitTest));
		return emailModel;
	}

	/**
	 * Returns the country names from the user's selected ISO Codes
	 */
	public String getDestinations(String selectedISOCodes) throws DaoException {
        if (selectedISOCodes != null && !selectedISOCodes.equals("")) {
		CountryMappingDao countries = new CountryMappingDao();
		CountryMapping userSelectedCountries = countries.getSelectedCountryNames(selectedISOCodes);

		// currently limited to 5 countries due to EDM design
		return userSelectedCountries.getSelectedCountries(5);
			}

        return "";
	}

	private void setupRankingDetails(TravelBestPriceEmailModel emailModel, Long transactionId) throws DaoException {
		RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
		List<RankingDetail> ranking = rankingDetailsDao.getLastestTopFiveRankings(transactionId);

		List<TravelBestPriceRanking> bestPriceRankings = new ArrayList<TravelBestPriceRanking>();
		for(RankingDetail rankingDetail : ranking) {
			TravelBestPriceRanking bestPriceRanking = new TravelBestPriceRanking();
			bestPriceRanking.setProviderName(rankingDetail.getProperty("providerName"));
			bestPriceRanking.setPremium(rankingDetail.getProperty("price"));
			bestPriceRanking.setPremiumText(rankingDetail.getProperty("priceText"));
			bestPriceRanking.setProductName(rankingDetail.getProperty("productName"));
			bestPriceRanking.setMedical(rankingDetail.getProperty("medical"));
			bestPriceRanking.setExcess(rankingDetail.getProperty("excess"));
			bestPriceRanking.setLuggage(rankingDetail.getProperty("luggage"));
			bestPriceRanking.setCancellation(rankingDetail.getProperty("cxdfee"));
			bestPriceRanking.setCoverLevelType(rankingDetail.getProperty("coverLevelType"));
			bestPriceRanking.setSmallLogo(rankingDetail.getProperty("service") + ".png");

			bestPriceRankings.add(bestPriceRanking);
		}
		emailModel.setRankings(bestPriceRankings);
	}


}