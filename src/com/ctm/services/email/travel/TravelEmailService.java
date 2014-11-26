package com.ctm.services.email.travel;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.RankingDetailsDao;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.EmailMaster;
import com.ctm.model.RankingDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.TravelBestPriceEmailModel;
import com.ctm.model.email.TravelBestPriceRanking;
import com.ctm.model.formatter.email.travel.TravelBestPriceExactTargetFormatter;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.model.travel.Destination;
import com.ctm.services.email.BestPriceEmailHandler;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.EmailUrlService;
import com.ctm.services.email.ExactTargetEmailSender;
import com.disc_au.web.go.Data;

public class TravelEmailService extends EmailServiceHandler implements BestPriceEmailHandler {

	private static final String VERTICAL = VerticalType.TRAVEL.getCode();

	@SuppressWarnings("unused")
	private static final Logger logger = Logger.getLogger(TravelEmailService.class.getName());

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

		ExactTargetEmailSender<TravelBestPriceEmailModel> emailSender = new ExactTargetEmailSender<TravelBestPriceEmailModel>(pageSettings);
		
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
			emailModel.setOptIn((boolean) (data.get("travel/marketing") != null && data.get("travel/marketing").equals("Y")));

			String price_presentation_url = pageSettings.getBaseUrl() + "travel_quote.jsp?action=load&type=bestprice&id=" + transactionId + "&hash=" + emailDetails.getHashedEmail() + "&vertical=travel&type="+(String) data.get("travel/policyType");
			emailModel.setCompareResultsURL(price_presentation_url);


			String pt = (String) data.get("travel/policyType");
			emailModel.setPolicyType(pt.equals("S") ? "ST" : "AMT");
			emailModel.setDuration((String) data.get("travel/soapDuration"));

			emailModel.setDestinations(getDestinations(data.get("travel/destinations/*/*")));

			setupRankingDetails(emailModel , transactionId);
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

	public String getDestinations(Object destinationsObj) {
		String destinations = "";
		if (destinationsObj instanceof String) {
			destinations  = Destination.findDescriptionByCode((String) destinationsObj);
		} else if (destinationsObj instanceof List) {
			@SuppressWarnings("unchecked")
			List<String> destList = (List<String>) destinationsObj;

			int maxDestinations = 5;
			int listSize = destList.size();

			String separator = "";
			for (int i = 0; i < listSize && i < maxDestinations; i++) {
				destinations += separator + Destination.findDescriptionByCode(destList.get(i));
				separator = ", ";
			}

			// If there is more than 5 destinations, we want to append the text more ....
			if (listSize > maxDestinations) {
				destinations += ", more ...";
			}
		}
		return destinations;
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
			bestPriceRanking.setSmallLogo(rankingDetail.getProperty("service") + ".png");

			bestPriceRankings.add(bestPriceRanking);
		}
		emailModel.setRankings(bestPriceRankings);
	}


}