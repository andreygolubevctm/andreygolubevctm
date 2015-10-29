package com.ctm.services.email.travel;

import com.ctm.web.core.dao.CountryMappingDao;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.dao.transaction.TransactionDao;
import com.ctm.exceptions.*;
import com.ctm.model.CountryMapping;
import com.ctm.model.EmailMaster;
import com.ctm.model.RankingDetail;
import com.ctm.model.content.Content;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.TravelBestPriceEmailModel;
import com.ctm.model.email.TravelBestPriceRanking;
import com.ctm.model.formatter.email.travel.TravelBestPriceExactTargetFormatter;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;
import com.ctm.services.email.*;
import com.disc_au.web.go.Data;

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
	public void send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress,transactionId);
				break;
			default:
				break;
		}
	}

	@Override
	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);

		splitTestEnabledKey = BestPriceEmailHandler.SPLIT_TESTING_ENABLED;

		ExactTargetEmailSender<TravelBestPriceEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings, transactionId);

		try {
			EmailMaster emailDetails = new EmailMaster();
			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setSource("QUOTE");
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE",  request.getRemoteAddr());

			if(!isTestEmailAddress) {
				emailSender.sendToExactTarget(new TravelBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId));
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
			emailModel.setOldestAge((String) data.get("travel/oldest"));

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