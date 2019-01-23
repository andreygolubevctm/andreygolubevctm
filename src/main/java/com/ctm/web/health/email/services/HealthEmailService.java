package com.ctm.web.health.email.services;

import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.dao.GeneralDao;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.*;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.exceptions.*;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailEventRequest;
import com.ctm.web.email.EmailEventType;
import com.ctm.web.email.EmailResponse;
import com.ctm.web.email.MarketingAutomationEmailService;
import com.ctm.web.health.email.formatter.HealthBestPriceExactTargetFormatter;
import com.ctm.web.health.email.model.HealthBestPriceEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceRanking;
import com.ctm.web.health.email.model.HealthProductBrochuresEmailModel;
import com.ctm.web.health.email.model.PolicyHolderModel;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.request.HealthEmailBrochureRequest;
import com.ctm.web.health.quote.model.ResponseAdapterV2;
import com.ctm.web.health.services.ProviderContentService;
import com.ctm.web.health.services.HealthSelectedProductService;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jms.Session;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.*;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HealthEmailService extends EmailServiceHandler implements BestPriceEmailHandler, ProductBrochuresEmailHandler, ApplicationEmailHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(HealthEmailService.class);

	private static final String VERTICAL = VerticalType.HEALTH.getCode();

	private final AccessTouchService accessTouchService;
	private final SessionDataServiceBean sessionDataService;
	private MarketingAutomationEmailService marketingAutomationEmailService;

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private GeneralDao generalDao;
	private ProviderContentService providerContentService;
	private ContentDao contentDao;
	private String optInMailingName;
	private final EmailUrlService urlService;
	private final EmailUrlServiceOld urlServiceOld;

	public HealthEmailService(PageSettings pageSettings,
							  EmailMode emailMode,
							  EmailDetailsService emailDetailsService,
							  ContentDao contentDao,
							  EmailUrlService urlService,
							  AccessTouchService accessTouchService,
							  EmailUrlServiceOld urlServiceOld,
							  SessionDataServiceBean sessionDataService,
							  IPAddressHandler ipAddressHandler,
							  GeneralDao generalDao,
							  ProviderContentService providerContentService,
							  MarketingAutomationEmailService marketingAutomationEmailService) {
		super(pageSettings, emailMode,ipAddressHandler);
		this.emailDetailsService = emailDetailsService;
		this.contentDao = contentDao;
		this.urlService = urlService;
		this.urlServiceOld = urlServiceOld;
		this.accessTouchService = accessTouchService;
		this.sessionDataService = sessionDataService;
		this.generalDao = generalDao;
		this.providerContentService = providerContentService;
		this.marketingAutomationEmailService = marketingAutomationEmailService;
	}

	@Override
	public String send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress,transactionId);
				break;
			case PRODUCT_BROCHURES:
				if (request.getRequestURI().toLowerCase().contains("get/link")) {
					return sendProductBrochureEmail(request, emailAddress, transactionId, true);
				} else {
					sendProductBrochureEmail(request, emailAddress,transactionId);
				}
				break;
			default:
				break;
		}
		return "";
	}

	@Override
	public String send(HttpServletRequest request, String emailAddress,
					   long transactionId, long productId) throws SendEmailException {
		switch (emailMode) {
			case APP:
				return sendApplicationEmail(request, emailAddress, transactionId, productId);
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
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE",  ipAddressHandler.getIPAddress(request));
			if(!isTestEmailAddress) {
				return emailSender.sendToExactTarget(new HealthBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId, request));
			} else {
				return "";
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  transactionId  ,  e);
		}
	}

	@Override
	public String sendApplicationEmail(HttpServletRequest request, String emailAddress, long transactionId, long productId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(ApplicationEmailHandler.MAILING_NAME_KEY);
		try {
			EmailMaster emailDetails = new EmailMaster();
			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setSource("APPLICATION");

			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, getOperatorFromRequest(request),  ipAddressHandler.getIPAddress(request));
			if(!isTestEmailAddress) {
				EmailResponse response = marketingAutomationEmailService.sendEventEmail(buildApplicationEmailModel(emailDetails, transactionId, productId, request));
				if(!response.getSuccess()){
					LOGGER.info("An error occurred sending the Health application confirmation email via the marketing automation service - Reason: {}", response.getMessage());
					return "0";
				}
				return response.getMessage();
			} else {
				return "";
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress + " transactionId:" +  transactionId  ,  e);
		}
	}

	@Override
	public void sendProductBrochureEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {

		sendProductBrochureEmail(request, emailAddress, transactionId, false);
	}

	private String sendProductBrochureEmail(HttpServletRequest request, String emailAddress, long transactionId, boolean blockEmailSending) throws SendEmailException {
		HealthEmailBrochureRequest emailBrochureRequest = new HealthEmailBrochureRequest();
		emailBrochureRequest.provider = request.getParameter("provider");
		emailBrochureRequest.productName = request.getParameter("productName");
		emailBrochureRequest.transactionId = transactionId;
		accessTouchService.setRequest(request);
		String productID = request.getParameter("productId");
		productID = productID==null?"":productID.replaceAll("PHIO-HEALTH-","");
		accessTouchService.recordTouchWithProductCodeDeprecated(emailBrochureRequest.transactionId,
				Touch.TouchType.BROCHURE.getCode(), productID);

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
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(emailBrochureRequest.transactionId, emailDetails, "ONLINE" ,  ipAddressHandler.getIPAddress(request));

			if (blockEmailSending) {
				return buildProductBrochureEmailModel(emailDetails, request, emailBrochureRequest, true).getApplyUrl();
			} else if(!isTestEmailAddress) {
				EmailResponse response = marketingAutomationEmailService.sendEventEmail(buildProductBrochureEmailModel(emailDetails, request, emailBrochureRequest, false));
				if(!response.getSuccess()){
					LOGGER.info("An error occurred sending the Health brochure email via the marketing automation service - Reason: {}", response.getMessage());
				}
			}
			return "";

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
				Map<String, String> otherEmailParameters = new HashMap<>();
				otherEmailParameters.put(EmailUrlService.CID, "em:cm:health:300994");
				otherEmailParameters.put(EmailUrlService.ET_RID, "172883275");
				otherEmailParameters.put(EmailUrlService.UTM_SOURCE, "health_quote_" + LocalDate.now().getYear());
				otherEmailParameters.put(EmailUrlService.UTM_MEDIUM, "email");
				otherEmailParameters.put(EmailUrlService.UTM_CAMPAIGN, "health_quote");
				emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
				emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
				emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "bestprice");
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailParameters.put(EmailUrlService.VERTICAL, "health");

				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));

				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
				emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, emailParameters, otherEmailParameters));
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

	private EmailEventRequest buildApplicationEmailModel(EmailMaster emailDetails, long transactionId, long productId, HttpServletRequest request) throws SendEmailException {

		Optional<HealthRequest> data = Optional.ofNullable((HealthRequest) request.getAttribute("requestData"));
		final Data dataBucket;
		final JSONObject productJSON;
		try {
			dataBucket = sessionDataService.getDataForTransactionId(request, Long.toString(transactionId), true);
			final String productSelected = new HealthSelectedProductService().getProductXML(transactionId, productId);
			productJSON = new JSONObject(productSelected);
		} catch (DaoException | JSONException | SessionException | SessionExpiredException e) {
			throw new SendEmailException("Failed to buildApplicationEmailModel", e);
		}

		final String confirmationId = (String)request.getAttribute("confirmationId");

		EmailEventRequest emailEventRequest = new EmailEventRequest();
		emailEventRequest.setVerticalCode(VERTICAL);

		final String premiumFrequency = data.map(HealthRequest::getQuote)
				.map(HealthQuote::getPayment)
				.map(Payment::getDetails)
				.map(PaymentDetails::getFrequency)
				.orElse("");
		emailEventRequest.setPremiumFrequency(premiumFrequency);

		try {
			final PaymentType paymentType = data.map(HealthRequest::getQuote)
					.map(HealthQuote::getPayment)
					.map(Payment::getDetails)
					.map(PaymentDetails::getType)
					.map(PaymentType::findByCode)
					.orElseThrow(() -> new SendEmailException("Failed to build emailEventRequest: PaymentType not set"));

			JSONObject pricing = getJsonObject(productJSON, "price", 0)
					.flatMap(j -> getJsonObject(j, "paymentTypePremiums"))
					.flatMap(j -> getJsonObject(j, ResponseAdapterV2.getPaymentType(paymentType)))
					.flatMap(j -> getJsonObject(j, premiumFrequency))
					.orElseThrow(() -> new SendEmailException("Failed to build emailEventRequest: Unable to find premium"));

			String productType = getJsonObject(productJSON, "price", 0)
					.flatMap(j -> getJsonObject(j,"info")).map(x -> {
						try {
							return x.getString("ProductType");
						} catch (JSONException ex) {
							return "";
						}
					}).orElse("");
			emailEventRequest.setCoverType(productType);
			//emailEventRequest.setCoverType(getParamSafely(dataBucket, "health/situation/coverType"));
			emailEventRequest.setPremium(pricing.getString("text"));
			emailEventRequest.setPremiumLabel(pricing.getString("pricing"));
		} catch (JSONException e) {
			throw new SendEmailException("Failed to build emailEventRequest", e);
		}

		emailEventRequest.setEventType(EmailEventType.HEALTH_APPLICATION);
		emailEventRequest.setEmailAddress(emailDetails.getEmailAddress());
		emailEventRequest.setEstablishContactKey(true);
		emailEventRequest.setFirstName(HealthEmailMapper.getFirstName(emailDetails, data));
		emailEventRequest.setTransactionId(String.valueOf(transactionId));
		final String providerName = data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProviderName)
				.orElse("");
		emailEventRequest.setProviderName(providerName);
		emailEventRequest.setProviderCode(providerName);
		emailEventRequest.setProviderPhone(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getProviderPhoneNumber)
				.orElse(""));

		emailEventRequest.setQuoteRef((String)request.getAttribute("providerQuoteId"));
		emailEventRequest.setBrand(pageSettings.getBrandCode());
		emailEventRequest.setExtrasPds(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getExtrasPDF)
				.orElse(""));
		emailEventRequest.setHospitalPds(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getFundData)
				.map(FundData::getHospitalPDF)
				.orElse(""));
		emailEventRequest.setProductDescription(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProductTitle)
				.orElse(""));

		try {
			emailEventRequest.setConfirmationUrl(createActionUrl(confirmationId));
		} catch (ConfigSettingException e) {
			LOGGER.error("Failed to build emailEventRequest {} ", kv("emailAddress", emailDetails.getEmailAddress()));
			throw new SendEmailException("Failed to build emailEventRequest - unable to retrieve confirmation url.", e);
		}
		String gaClientId = getParamSafely(dataBucket, "health/gaclientid");
		emailEventRequest.setGaClientId(gaClientId);

		return emailEventRequest;
	}

	private String getParamSafely(Data data, String param) {
		try {
			return (String) data.get(param);
		}
		catch(Exception e){
			LOGGER.warn("Field " + param + " not found before sending email");
		}
		return null;
	}

	private Optional<JSONObject> getJsonObject(JSONObject jsonObject, String key) {
		if (jsonObject.has(key)) {
			try {
				return Optional.of(jsonObject.getJSONObject(key));
			} catch (JSONException e) {
				throw new RuntimeException("Not able to get JSONObject", e);
			}
		} else {
			return Optional.empty();
		}
	}

	private Optional<String> getString(JSONObject jsonObject, String key) {
		if (jsonObject.has(key)) {
			try {
				return Optional.of(jsonObject.getString(key));
			} catch (JSONException e) {
				throw new RuntimeException("Not able to get JSONObject", e);
			}
		} else {
			return Optional.empty();
		}
	}

	private Optional<JSONObject> getJsonObject(JSONObject jsonObject, String key, int index) throws SendEmailException {
		if (jsonObject.has(key)) {
			try {
				final JSONArray jsonArray = jsonObject.getJSONArray(key);
				if (index < jsonArray.length()) {
					return Optional.of(jsonArray.getJSONObject(index));
				}
			} catch (JSONException e) {
				throw new SendEmailException("Not able to get JSONObject", e);
			}
		}
		return Optional.empty();
	}

	private PolicyHolderModel createPolicyHolderModel(Person person) {
		final PolicyHolderModel holder = new PolicyHolderModel();
		holder.setFirstName(person.getFirstname());
		holder.setLastName(person.getSurname());
		holder.setDateOfBirth(person.getDob());
		return holder;
	}

	private PolicyHolderModel createPolicyHolderModel(Dependant dependant) {
		final PolicyHolderModel holder = new PolicyHolderModel();
		holder.setFirstName(dependant.getFirstName());
		holder.setLastName(dependant.getLastname());
		holder.setDateOfBirth(dependant.getDob());
		return holder;
	}

	private String createActionUrl(final String confirmationId) throws ConfigSettingException {
		StringBuilder sb = new StringBuilder()
				.append(pageSettings.getBaseUrl())
				.append("health_quote.jsp?action=confirmation&ConfirmationID=")
				.append(confirmationId);

		if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.PRO){
			sb.append("&sssdmh=dm14.240054");
		} else {
			sb.append("&sssdmh=dm14.240016");
		}
		sb.append("&cid=em:em:health:101911&utm_source=email&utm_medium=email&utm_campaign=email_|_health_|_confirmation&utm_content=review_your_details");
		return sb.toString();
	}


	private EmailEventRequest buildProductBrochureEmailModel(EmailMaster emailDetails, HttpServletRequest request, HealthEmailBrochureRequest emailBrochureRequest, boolean blockEmailSending) throws SendEmailException {
		EmailEventRequest emailEventRequest = new EmailEventRequest();
		emailEventRequest.setEmailAddress(emailDetails.getEmailAddress());
		emailEventRequest.setEventType(EmailEventType.HEALTH_PDS);
		emailEventRequest.setEstablishContactKey(true);
		emailEventRequest.setFirstName(emailDetails.getFirstName());
		emailEventRequest.setLastName(emailDetails.getLastName());
		emailEventRequest.setTransactionId(Long.toString(emailBrochureRequest.transactionId));
		emailEventRequest.setProviderName(emailBrochureRequest.provider);
		emailEventRequest.setProviderCode(emailBrochureRequest.provider);
		emailEventRequest.setProviderPhone(null);
		emailEventRequest.setQuoteRef(Long.toString(emailBrochureRequest.transactionId));
		emailEventRequest.setBrand(pageSettings.getBrandCode());
		emailEventRequest.setCoverType(request.getParameter("coverType"));
		emailEventRequest.setPremium(request.getParameter("premium"));
		emailEventRequest.setPremiumLabel(request.getParameter("premiumText"));
		emailEventRequest.setPremiumFrequency(request.getParameter("premiumFrequency"));
		emailEventRequest.setProductDescription(emailBrochureRequest.productName);
		emailEventRequest.setVerticalCode(VERTICAL);

		try {
			OpeningHoursService openingHoursService = new OpeningHoursService();
			emailEventRequest.setCallCentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
			emailEventRequest.setHospitalPds( pageSettings.getBaseUrl() + request.getParameter("hospitalPDSUrl"));
			emailEventRequest.setExtrasPds(pageSettings.getBaseUrl() + request.getParameter("extrasPDSUrl"));
			emailEventRequest.setPhoneNumber(getCallCentreNumber());

			String productId = request.getParameter("productId");
			String productCode = request.getParameter("productCode");
			String cid = "em:cm:health:301005";
			String utmSource = "health_pds_" + LocalDate.now().getYear();
			String utmMedium = "email";
			String utmCampaign = "health_pds";
			boolean isCallCenter = SessionUtils.isCallCentre(request.getSession());
			final Data dataBucket = sessionDataService.getDataForTransactionId(request, Long.toString(emailBrochureRequest.transactionId), false);

			if (isCallCenter && dataBucket.getString("health/simples/contactType").equals("webchat") && blockEmailSending) {
				cid = "livechat";
				utmSource = "livechat";
				utmMedium = "livechat";
				utmCampaign = "livechat";
			}
			emailEventRequest.setSource(isCallCenter ? "simples" : "ONLINE");

			if(Boolean.valueOf(getPageSetting("emailTokenEnabled"))) {
				Map<String, String> emailParameters = new HashMap<>();
				Map<String, String> otherEmailParameters = new HashMap<>();
				otherEmailParameters.put(EmailUrlService.CID, cid);
				otherEmailParameters.put(EmailUrlService.ET_RID, "172883275");
				otherEmailParameters.put(EmailUrlService.UTM_SOURCE, utmSource);
				otherEmailParameters.put(EmailUrlService.UTM_MEDIUM, utmMedium);
				otherEmailParameters.put(EmailUrlService.UTM_CAMPAIGN, utmCampaign);
				otherEmailParameters.put(EmailUrlService.PRODUCT_CODE, productCode);
				emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(emailBrochureRequest.transactionId));
				emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
				emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "brochures");
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
				emailParameters.put(EmailUrlService.VERTICAL, "health");
				emailParameters.put(EmailUrlService.PRODUCT_ID, productId);
				EmailTokenService.setProductName(emailBrochureRequest.productName, emailParameters);
				emailEventRequest.setApplyUrl(urlService.getApplyUrl(emailDetails, emailParameters, otherEmailParameters));
			} else {
				emailEventRequest.setApplyUrl(urlServiceOld.getApplyUrl(emailDetails, emailBrochureRequest.transactionId, "bestprice", productId, emailBrochureRequest.productName));
			}
		} catch (EnvironmentException | VerticalException | ConfigSettingException | DaoException | SessionException | SessionExpiredException e) {
			throw new SendEmailException("An error occurred retrieving parameters for Health PDS email", e);
		}

		emailEventRequest.setOptIn(emailDetails.getOptedInMarketing(VERTICAL) ? "Y" : "N");
		emailEventRequest.setUid(getOperatorFromRequest(request));
		return emailEventRequest;
	}

	private void setupRankingDetails(HealthBestPriceEmailModel emailModel, Long transactionId) throws DaoException, SendEmailException, ConfigSettingException {
		RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
		List<RankingDetail> ranking = rankingDetailsDao.getLastestTopFiveRankings(transactionId);
		if(ranking.size() > 0){
			emailModel.setPremiumFrequency(ranking.get(0).getProperty("frequency"));
			emailModel.setCoverType1(ranking.get(0).getProperty("productName"));
			emailModel.setHealthMembership(ranking.get(0).getProperty("healthMembership"));
			emailModel.setHealthSituation(ranking.get(0).getProperty("healthSituation"));
			emailModel.setBenefitCodes(ranking.get(0).getProperty("benefitCodes"));
			emailModel.setCoverType(ranking.get(0).getProperty("coverType"));
			emailModel.setPrimaryCurrentPHI(ranking.get(0).getProperty("primaryCurrentPHI"));
		} else {
			throw new SendEmailException("no rankings found transactionId:" + transactionId);
		}

		final String baseUrl = pageSettings.getBaseUrl();

		List<HealthBestPriceRanking> bestPriceRankings = new ArrayList<>();
		for(RankingDetail rankingDetail : ranking) {
			HealthBestPriceRanking bestPriceRanking = new HealthBestPriceRanking();
			bestPriceRanking.setPremium(rankingDetail.getProperty("premium"));
			bestPriceRanking.setPremiumText(rankingDetail.getProperty("premiumText"));
			bestPriceRanking.setProviderName(rankingDetail.getProperty("providerName"));
			bestPriceRanking.setSmallLogo(rankingDetail.getProperty("provider").toLowerCase() + ".png");

			bestPriceRanking.setProductName(rankingDetail.getProperty("productName"));
			bestPriceRanking.setHospitalPdsUrl(Optional.ofNullable(rankingDetail.getProperty("hospitalPdsUrl")).map(v -> baseUrl + v).orElse(null));
			bestPriceRanking.setExtrasPdsUrl(Optional.ofNullable(rankingDetail.getProperty("extrasPdsUrl")).map(v -> baseUrl + v).orElse(null));
			bestPriceRanking.setSpecialOffer(rankingDetail.getProperty("specialOffer"));
			bestPriceRanking.setSpecialOfferTerms(rankingDetail.getProperty("specialOfferTerms"));
			bestPriceRanking.setPremiumTotal(rankingDetail.getProperty("price_actual"));
			bestPriceRanking.setExcessPerAdmission(rankingDetail.getProperty("excessPerAdmission"));
			bestPriceRanking.setExcessPerPerson(rankingDetail.getProperty("excessPerPerson"));
			bestPriceRanking.setExcessPerPolicy(rankingDetail.getProperty("excessPerPolicy"));
			bestPriceRanking.setCoPayment(rankingDetail.getProperty("coPayment"));

			bestPriceRankings.add(bestPriceRanking);
		}
		emailModel.setRankings(bestPriceRankings);
	}

	private String getCallCentreNumber() throws DaoException {
		Content content = contentDao.getByKey("callCentreNumber", ApplicationService.getServerDate(), false);
		return content != null ? content.getContentValue() : "";
	}

	private String getOperatorFromRequest(HttpServletRequest request){
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null && StringUtils.isNotBlank(authenticatedData.getUid())) {
				return authenticatedData.getUid();
			} else {
				return "ONLINE";
			}
		} else {
			return "ONLINE";
		}
	}

}