package com.ctm.web.health.email.services;

import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.BestPriceRanking;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.*;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.health.email.model.HealthBestPriceEmailModel;
import com.ctm.web.health.email.model.HealthProductBrochuresEmailModel;
import com.ctm.web.health.email.formatter.HealthBestPriceExactTargetFormatter;
import com.ctm.web.health.email.formatter.HealthProductBrochuresExactTargetFormatter;
import com.ctm.web.health.model.request.HealthEmailBrochureRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HealthEmailService extends EmailServiceHandler implements BestPriceEmailHandler, ProductBrochuresEmailHandler {

	private static final String VERTICAL = VerticalType.HEALTH.getCode();

	private final AccessTouchService accessTouchService;

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private ContentDao contentDao;
	private String optInMailingName;
	private final EmailUrlService urlService;
	private final EmailUrlServiceOld urlServiceOld;

	public HealthEmailService(PageSettings pageSettings, EmailMode emailMode,
							  EmailDetailsService emailDetailsService,
														ContentDao contentDao,
														EmailUrlService urlService,
														AccessTouchService accessTouchService,
							  							EmailUrlServiceOld urlServiceOld) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
		this.contentDao = contentDao;
		this.urlService = urlService;
		this.urlServiceOld = urlServiceOld;
		this.accessTouchService = accessTouchService;
	}

	@Override
	public void send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress,transactionId);
				break;
			case PRODUCT_BROCHURES:
				sendProductBrochureEmail(request, emailAddress,transactionId);
				break;
			default:
				break;
		}
	}

	@Override
	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(BestPriceEmailHandler.MAILING_NAME_KEY);
		optInMailingName = getPageSetting(BestPriceEmailHandler.OPT_IN_MAILING_NAME);
		ExactTargetEmailSender<HealthBestPriceEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings, transactionId);
		try {
			EmailMaster emailDetails = new EmailMaster();
			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setSource("QUOTE");
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE",  request.getRemoteAddr());
			if(!isTestEmailAddress) {
				emailSender.sendToExactTarget(new HealthBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId,request));
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  transactionId  ,  e);
		}
	}

	@Override
	public void sendProductBrochureEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		HealthEmailBrochureRequest emailBrochureRequest = new HealthEmailBrochureRequest();
		emailBrochureRequest.provider = request.getParameter("provider");
		emailBrochureRequest.productName = request.getParameter("productName");
		emailBrochureRequest.transactionId = transactionId;
		accessTouchService.setRequest(request);
		String productID = request.getParameter("productId");
		productID = productID==null?"":productID.replaceAll("PHIO-HEALTH-","");
		accessTouchService.recordTouchWithProductCode(emailBrochureRequest.transactionId,
				Touch.TouchType.BROCHURE.getCode(),productID);

		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(ProductBrochuresEmailHandler.MAILING_NAME_KEY);
		ExactTargetEmailSender<HealthProductBrochuresEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings,transactionId);
		try {
			EmailMaster emailDetails = new EmailMaster();

			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setOptedInMarketing("Y".equals(request.getParameter("marketing")), VERTICAL);

			emailDetails.setFirstName(request.getParameter("firstName"));
			emailDetails.setLastName(request.getParameter("lastName"));

			emailDetails.setSource("BROCHURE");

			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(emailBrochureRequest.transactionId, emailDetails, "ONLINE" ,  request.getRemoteAddr());
			if(!isTestEmailAddress) {
				emailSender.sendToExactTarget(new HealthProductBrochuresExactTargetFormatter(), buildProductBrochureEmailModel(emailDetails, request, emailBrochureRequest));
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  emailBrochureRequest.transactionId  ,  e);
		}
	}

	private HealthBestPriceEmailModel buildBestPriceEmailModel(EmailMaster emailDetails, long transactionId,HttpServletRequest  request) throws SendEmailException {
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		HealthBestPriceEmailModel emailModel = new HealthBestPriceEmailModel();
		buildEmailModel(emailDetails, emailModel);
		OpeningHoursService openingHoursService = new OpeningHoursService();
		try {
			emailModel.setCallcentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setOptIn(optedIn);
			emailModel.setPhoneNumber(getCallCentreNumber());
			setupRankingDetails(emailModel, transactionId);
			emailModel.setTransactionId(transactionId);

			if(Boolean.valueOf(getPageSetting("emailTokenEnabled"))) {
				Map<String, String> emailParameters = new HashMap<>();
				emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
				emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
				emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailParameters.put(EmailUrlService.VERTICAL, "health");

				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));

				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
				emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, emailParameters));
			} else {
				emailModel.setUnsubscribeURL(urlServiceOld.getUnsubscribeUrl(emailDetails));
				emailModel.setApplyUrl(urlServiceOld.getApplyUrl(emailDetails, transactionId, "bestprice"));
			}
		} catch (DaoException|EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}
		if(optedIn) {
			setCustomerKey(emailModel,optInMailingName);
		} else {
			setCustomerKey(emailModel, mailingName);
		}
		return emailModel;
	}


	private HealthProductBrochuresEmailModel buildProductBrochureEmailModel(EmailMaster emailDetails, HttpServletRequest request, HealthEmailBrochureRequest emailBrochureRequest) throws SendEmailException {
		HealthProductBrochuresEmailModel emailModel = new HealthProductBrochuresEmailModel();
		buildEmailModel(emailDetails, emailModel);
		String productId = request.getParameter("productId");
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		OpeningHoursService openingHoursService = new OpeningHoursService();

		try {
			emailModel.setPhoneNumber(getCallCentreNumber());

			emailModel.setCallcentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
			emailModel.setTransactionId(emailBrochureRequest.transactionId);
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setLastName(emailDetails.getLastName());
			emailModel.setOptIn(optedIn);

			if(Boolean.valueOf(getPageSetting("emailTokenEnabled"))) {
				Map<String, String> emailParameters = new HashMap<>();
				emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(emailBrochureRequest.transactionId));
				emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
				emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "brochures");
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
				emailParameters.put(EmailUrlService.VERTICAL, "health");
				emailParameters.put(EmailUrlService.PRODUCT_ID, productId);
				emailParameters.put(EmailUrlService.PRODUCT_NAME, emailBrochureRequest.productName);
				emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, emailParameters));

				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailParameters.remove(EmailUrlService.PRODUCT_ID);
				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));
			} else {
				emailModel.setApplyUrl(urlServiceOld.getApplyUrl(emailDetails, emailBrochureRequest.transactionId, "bestprice", productId, emailBrochureRequest.productName));
				emailModel.setUnsubscribeURL(urlServiceOld.getUnsubscribeUrl(emailDetails));
			}
		} catch (DaoException|EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  emailBrochureRequest.transactionId  ,  e);
		}
		setCustomerKey(emailModel, mailingName);

		emailModel.setProductName(request.getParameter("productName"));
		emailModel.setPremium(request.getParameter("premium"));
		emailModel.setPremiumFrequency(request.getParameter("premiumFrequency"));
		emailModel.setPremiumText(request.getParameter("premiumText"));
		emailModel.setProvider(emailBrochureRequest.provider);
		emailModel.setSmallLogo(emailBrochureRequest.provider.toLowerCase() + ".png");
		try {
			emailModel.setHospitalPDSUrl( pageSettings.getBaseUrl() + request.getParameter("hospitalPDSUrl"));
			emailModel.setExtrasPDSUrl(pageSettings.getBaseUrl() + request.getParameter("extrasPDSUrl"));
		} catch (EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to get base url", e);
		}
		return emailModel;
	}

	private void setupRankingDetails(HealthBestPriceEmailModel emailModel, Long transactionId) throws DaoException, SendEmailException {
		RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
		List<RankingDetail> ranking = rankingDetailsDao.getLastestTopFiveRankings(transactionId);
		if(ranking.size() > 0){
			emailModel.setPremiumFrequency(ranking.get(0).getProperty("frequency"));
			emailModel.setCoverType1(ranking.get(0).getProperty("productName"));
		} else {
			throw new SendEmailException("no rankings found transactionId:" + transactionId);
		}

		ArrayList<BestPriceRanking> bestPriceRankings = new ArrayList<BestPriceRanking>();
		for(RankingDetail rankingDetail : ranking) {
			BestPriceRanking bestPriceRanking = new BestPriceRanking();
			bestPriceRanking.setPremium(rankingDetail.getProperty("premium"));
			bestPriceRanking.setPremiumText(rankingDetail.getProperty("premiumText"));
			bestPriceRanking.setProviderName(rankingDetail.getProperty("providerName"));
			bestPriceRanking.setSmallLogo(rankingDetail.getProperty("provider").toLowerCase() + ".png");
			bestPriceRankings.add(bestPriceRanking);
		}
		emailModel.setRankings(bestPriceRankings);
	}

	private String getCallCentreNumber() throws DaoException {
		Content content = contentDao.getByKey("callCentreNumber", ApplicationService.getServerDate(), false);
		return content != null ? content.getContentValue() : "";
	}

}