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
import org.apache.commons.lang3.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class TravelEmailService extends EmailServiceHandler implements BestPriceEmailHandler {

	private static final String VERTICAL = VerticalType.TRAVEL.getCode();

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private final EmailUrlService urlService;
	private final EmailUrlServiceOld urlServiceOld;
	private Data data;

	public TravelEmailService(PageSettings pageSettings, EmailMode emailMode, EmailDetailsService emailDetailsService, EmailUrlService urlService, Data data, EmailUrlServiceOld urlServiceOld) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
		this.urlService = urlService;
		this.data = data;
		this.urlServiceOld = urlServiceOld;
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
			String dob1 = (String) data.get("travel/travellers/traveller1DOB");
			String dob2 = (String) data.get("travel/travellers/traveller2DOB");
			LocalDate dob = parseStringToLocalDate(dob1);
			emailModel.setAdult1Age(getAgeFromDob(dob)+"");
			if(StringUtils.isNotEmpty(dob2)) {
				dob = parseStringToLocalDate(dob2);
				emailModel.setAdult2Age(getAgeFromDob(dob)+"");
			}
			// default to standard if travel/coverLevelTab xpath is not found
			String coverLevelTab = (String) data.get("travel/coverLevelTab");
			coverLevelTab = (coverLevelTab == null || coverLevelTab.equals(""))  ? "standard" : coverLevelTab;
			emailModel.setCoverLevelTabsType(coverLevelTab);

			Date serverDate = ApplicationService.getApplicationDate(null);
			Content content = ContentService.getInstance().getContent("CoverLevelTabKeys", pageSettings.getBrandId(), 2, serverDate, true);
			emailModel.setCoverLevelTabsDescription(content.getSupplementaryValueByKey(coverLevelTab+"EDMVar"));

			emailModel.setOptIn((boolean) (data.get("travel/marketing") != null && data.get("travel/marketing").equals("Y")));

			Map<String, String> emailParameters = new HashMap<>();
			emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
			emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
			emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
			emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
			emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
			emailParameters.put(EmailUrlService.VERTICAL, "travel");
			emailParameters.put(EmailUrlService.TRAVEL_POLICY_TYPE, (String) data.get("travel/policyType"));

			String pricePresentationUrl;
			if(Boolean.valueOf(pageSettings.getSetting("emailTokenEnabled"))) {
				pricePresentationUrl = urlService.getApplyUrl(emailDetails, emailParameters);
			} else {
				pricePresentationUrl = pageSettings.getBaseUrl() + "travel_quote.jsp?action=load&type=bestprice&id=" + transactionId + "&hash=" + emailDetails.getHashedEmail() + "&vertical=travel&type="+(String) data.get("travel/policyType");
			}
			emailModel.setCompareResultsURL(pricePresentationUrl);

			String pt = (String) data.get("travel/policyType");
			emailModel.setPolicyType(pt.equals("S") ? "ST" : "AMT");
			emailModel.setDuration((String) data.get("travel/soapDuration"));

			emailModel.setDestinations(getDestinations((String) data.get("travel/destination")));

			setupRankingDetails(emailModel, transactionId);
			emailModel.setTransactionId(transactionId);

			if(Boolean.valueOf(pageSettings.getSetting("emailTokenEnabled"))) {
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));
			} else {
				emailModel.setUnsubscribeURL(urlServiceOld.getUnsubscribeUrl(emailDetails));
			}
			emailModel.setApplyUrl(pricePresentationUrl);
		} catch (DaoException|EnvironmentException | VerticalException | ConfigSettingException e) {
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

	LocalDate parseStringToLocalDate(String date) {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("d/M/yyyy");
		return LocalDate.parse(date,dtf);

	}


	int getAgeFromDob(LocalDate dob) {
		final LocalDate today = LocalDate.now();
		final Period age = Period.between(dob,today);
		return age.getYears();
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