package com.ctm.services.email.health;

import com.ctm.dao.ContentDao;
import com.ctm.dao.RankingDetailsDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.*;
import com.ctm.model.EmailMaster;
import com.ctm.model.RankingDetail;
import com.ctm.model.Touch;
import com.ctm.model.content.Content;
import com.ctm.model.email.*;
import com.ctm.model.formatter.email.health.HealthApplicationExactTargetFormatter;
import com.ctm.model.formatter.email.health.HealthBestPriceExactTargetFormatter;
import com.ctm.model.formatter.email.health.HealthProductBrochuresExactTargetFormatter;
import com.ctm.model.health.form.*;
import com.ctm.model.request.health.HealthEmailBrochureRequest;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.providers.health.healthapply.model.response.HealthApplicationResponse;
import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import com.ctm.services.AccessTouchService;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.SessionDataService;
import com.ctm.services.email.*;
import com.ctm.services.simples.OpeningHoursService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ctm.logging.LoggingArguments.kv;

public class HealthEmailService extends EmailServiceHandler implements BestPriceEmailHandler, ProductBrochuresEmailHandler, ApplicationEmailHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(HealthEmailService.class);

	private static final String VERTICAL = VerticalType.HEALTH.getCode();

	private final AccessTouchService accessTouchService;
	private final SessionDataService sessionDataService;

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private ContentDao contentDao;
	private String optInMailingName;
	private final EmailUrlService urlService;

	public HealthEmailService(PageSettings pageSettings, EmailMode emailMode,
							  EmailDetailsService emailDetailsService,
														ContentDao contentDao,
														EmailUrlService urlService,
														AccessTouchService accessTouchService,
							  							SessionDataService sessionDataService) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
		this.contentDao = contentDao;
		this.urlService = urlService;
		this.accessTouchService = accessTouchService;
		this.sessionDataService = sessionDataService;
	}

	@Override
	public String send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress,transactionId);
				break;
			case PRODUCT_BROCHURES:
				sendProductBrochureEmail(request, emailAddress,transactionId);
				break;
			case APP:
				return sendApplicationEmail(request, emailAddress, transactionId);
			default:
				break;
		}
		return "";
	}

	@Override
	public String sendBestPriceEmail(HttpServletRequest request, String emailAddress,
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
				return emailSender.sendToExactTarget(new HealthBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId,request));
			} else {
				return "";
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  transactionId  ,  e);
		}
	}

	@Override
	public String sendApplicationEmail(HttpServletRequest request, String emailAddress,
								   long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(ApplicationEmailHandler.MAILING_NAME_KEY);
		ExactTargetEmailSender<HealthApplicationEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings, transactionId);
		try {
			EmailMaster emailDetails = new EmailMaster();
			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setSource("APPLICATION");

			final String operator;
			if (request != null && request.getSession() != null) {
				AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
				if(authenticatedData != null) {
					operator = authenticatedData.getUid();
				} else {
					operator = "ONLINE";
				}
			} else {
				operator = "ONLINE";
			}

			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, operator,  request.getRemoteAddr());
			if(!isTestEmailAddress) {
				return emailSender.sendToExactTarget(new HealthApplicationExactTargetFormatter(), buildApplicationEmailModel(emailDetails, transactionId, request));
			} else {
				return "";
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
			setupRankingDetails(emailModel , transactionId);
			emailModel.setTransactionId(transactionId);
			emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailDetails));
			emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, transactionId, "bestprice"));
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

	private HealthApplicationEmailModel buildApplicationEmailModel(EmailMaster emailDetails, long transactionId, HttpServletRequest request) throws SendEmailException {

		HealthApplyResponse applicationResponse = (HealthApplyResponse)request.getAttribute("applicationResponse");

		final HealthApplicationResponse response = applicationResponse.getPayload().getQuotes().get(0);

		Optional<HealthRequest> data = Optional.ofNullable((HealthRequest) request.getAttribute("requestData"));

		HealthApplicationEmailModel emailModel = new HealthApplicationEmailModel();
		emailModel.setEmailAddress(emailDetails.getEmailAddress());
		emailModel.setFirstName(emailDetails.getFirstName());
		emailModel.setBccEmail(response.getBccEmail());
		emailModel.setOptIn("Y".equals(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getOptInEmail)
				.orElseGet(() -> data.map(HealthRequest::getQuote)
						.map(HealthQuote::getSave)
						.map(Save::getMarketing)
						.orElse("N"))));
		emailModel.setOkToCall(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getContactDetails)
				.map(ContactDetails::getCall)
				.orElse("N"));
		emailModel.setTransactionId(transactionId);
		try {
			emailModel.setPhoneNumber(getCallCentreNumber());
		    emailModel.setActionUrl(createActionUrl(applicationResponse));
		} catch (ConfigSettingException | DaoException e) {
			LOGGER.error("Failed to buildApplicationEmailModel {} ", kv("emailAddress", emailDetails.getEmailAddress()));
			throw new SendEmailException("Failed to buildApplicationEmailModel", e);
		}
		emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailDetails));
		emailModel.setProductName(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProductTitle)
				.orElse(""));
		emailModel.setHealthFund(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProviderName)
				.orElse(""));
		emailModel.setProviderPhoneNumber(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getProviderPhoneNumber)
				.orElse(""));
		emailModel.setHospitalPdsUrl(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getHospitalPDF)
				.orElse(""));
		emailModel.setExtrasPdsUrl(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getExtrasPDF)
				.orElse(""));
		setCustomerKey(emailModel, mailingName);
		return emailModel;
	}

	private String createActionUrl(final HealthApplyResponse applicationResponse) throws ConfigSettingException {
		StringBuilder sb = new StringBuilder()
				.append(pageSettings.getBaseUrl())
				.append("health_quote.jsp?action=confirmation&ConfirmationID=")
				.append(applicationResponse.getConfirmationID());

		if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.PRO){
			sb.append("&sssdmh=dm14.240054");
		} else {
			sb.append("&sssdmh=dm14.240016");
		}
		sb.append("&cid=em:em:health:101911&utm_source=email&utm_medium=email&utm_campaign=email_|_health_|_confirmation&utm_content=review_your_details");
		return sb.toString();
	}


	private HealthProductBrochuresEmailModel buildProductBrochureEmailModel(EmailMaster emailDetails, HttpServletRequest request, HealthEmailBrochureRequest emailBrochureRequest) throws SendEmailException {
		HealthProductBrochuresEmailModel emailModel = new HealthProductBrochuresEmailModel();
		buildEmailModel(emailDetails, emailModel);
		String productId = request.getParameter("productId");
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		OpeningHoursService openingHoursService = new OpeningHoursService();

		try {
			emailModel.setPhoneNumber(getCallCentreNumber());
			emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, emailBrochureRequest.transactionId, "bestprice", productId, emailBrochureRequest.productName));
			emailModel.setCallcentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
			emailModel.setTransactionId(emailBrochureRequest.transactionId);
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setLastName(emailDetails.getLastName());
			emailModel.setOptIn(optedIn);
			emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailDetails));
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