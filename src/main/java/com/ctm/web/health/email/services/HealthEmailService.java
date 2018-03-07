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
import com.ctm.web.health.apply.model.response.HealthApplicationResponse;
import com.ctm.web.health.apply.model.response.HealthApplyResponse;
import com.ctm.web.health.email.formatter.HealthApplicationExactTargetFormatter;
import com.ctm.web.health.email.formatter.HealthBestPriceExactTargetFormatter;
import com.ctm.web.health.email.formatter.HealthProductBrochuresExactTargetFormatter;
import com.ctm.web.health.email.model.HealthApplicationEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceEmailModel;
import com.ctm.web.health.email.model.HealthBestPriceRanking;
import com.ctm.web.health.email.model.HealthProductBrochuresEmailModel;
import com.ctm.web.health.email.model.PolicyHolderModel;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.model.request.HealthEmailBrochureRequest;
import com.ctm.web.health.quote.model.ResponseAdapterV2;
import com.ctm.web.health.services.ProviderContentService;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.util.*;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;

public class HealthEmailService extends EmailServiceHandler implements BestPriceEmailHandler, ProductBrochuresEmailHandler, ApplicationEmailHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(HealthEmailService.class);

	private static final String VERTICAL = VerticalType.HEALTH.getCode();

	private final AccessTouchService accessTouchService;
	private final SessionDataServiceBean sessionDataService;

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
							  ProviderContentService providerContentService) {
		super(pageSettings, emailMode,ipAddressHandler);
		this.emailDetailsService = emailDetailsService;
		this.contentDao = contentDao;
		this.urlService = urlService;
		this.urlServiceOld = urlServiceOld;
		this.accessTouchService = accessTouchService;
		this.sessionDataService = sessionDataService;
		this.generalDao = generalDao;
		this.providerContentService = providerContentService;
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
				if(authenticatedData != null && StringUtils.isNotBlank(authenticatedData.getUid())) {
					operator = authenticatedData.getUid();
				} else {
					operator = "ONLINE";
				}
			} else {
				operator = "ONLINE";
			}

			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, operator,  ipAddressHandler.getIPAddress(request));
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

		String x = sendProductBrochureEmail(request, emailAddress, transactionId, false);
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
			String returnStr = "";

			EmailMaster emailDetails = new EmailMaster();

			emailDetails.setEmailAddress(emailAddress);
			emailDetails.setOptedInMarketing("Y".equals(request.getParameter("marketing")), VERTICAL);

			emailDetails.setFirstName(request.getParameter("firstName"));
			emailDetails.setLastName(request.getParameter("lastName"));

			emailDetails.setSource("BROCHURE");

			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(emailBrochureRequest.transactionId, emailDetails, "ONLINE" ,  ipAddressHandler.getIPAddress(request));

			if (blockEmailSending) {
				return buildProductBrochureEmailModel(emailDetails, request, emailBrochureRequest, true).getApplyURL();
			} else if(!isTestEmailAddress) {
				emailSender.sendToExactTarget(new HealthProductBrochuresExactTargetFormatter(), buildProductBrochureEmailModel(emailDetails, request, emailBrochureRequest, false));
			}

			return returnStr;

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

	private HealthApplicationEmailModel buildApplicationEmailModel(EmailMaster emailDetails, long transactionId, HttpServletRequest request) throws SendEmailException {

		HealthApplyResponse applicationResponse = (HealthApplyResponse)request.getAttribute("applicationResponse");

		final HealthApplicationResponse response = applicationResponse.getPayload();

		Optional<HealthRequest> data = Optional.ofNullable((HealthRequest) request.getAttribute("requestData"));


		final JSONObject productJSON;
		try {
			final Data dataBucket = sessionDataService.getDataForTransactionId(request, Long.toString(transactionId), true);
			final String productSelected = StringUtils.removeEnd(
					StringUtils.removeStart(dataBucket.getString("confirmation/health"), "<![CDATA["),
					"]]>");

			productJSON = new JSONObject(productSelected);
		} catch (DaoException | SessionException |JSONException e) {
			throw new SendEmailException("Failed to buildApplicationEmailModel", e);
		}


		final String confirmationId = (String)request.getAttribute("confirmationId");

		HealthApplicationEmailModel emailModel = new HealthApplicationEmailModel();
		emailModel.setEmailAddress(emailDetails.getEmailAddress());
		emailModel.setFirstName(HealthEmailMapper.getFirstName(emailDetails, data));
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
		    emailModel.setActionUrl(createActionUrl(confirmationId));
		} catch (ConfigSettingException | DaoException e) {
			LOGGER.error("Failed to buildApplicationEmailModel {} ", kv("emailAddress", emailDetails.getEmailAddress()));
			throw new SendEmailException("Failed to buildApplicationEmailModel", e);
		}

		try {
			if (Boolean.valueOf(getPageSetting("emailTokenEnabled"))) {
				Map<String, String> emailParameters = new HashMap<>();
				emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
				emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
				emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, "app");
				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailParameters.put(EmailUrlService.VERTICAL, "health");
				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));
			} else {
				emailModel.setUnsubscribeURL(urlServiceOld.getUnsubscribeUrl(emailDetails));
			}
		} catch (ConfigSettingException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}

		emailModel.setProductName(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProductTitle)
				.orElse(""));
		final String providerName = data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProviderName)
				.orElse("");
		emailModel.setHealthFund(providerName);
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

		// HLT-3676
		final String premiumFrequency = data.map(HealthRequest::getQuote)
				.map(HealthQuote::getPayment)
				.map(Payment::getDetails)
				.map(PaymentDetails::getFrequency)
				.orElse("");
		emailModel.setPremiumFrequency(premiumFrequency);

		emailModel.setProviderLogo(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getProvider)
				.map(p -> p.toLowerCase() + ".png")
				.orElse(""));

		try {

			final PaymentType paymentType = data.map(HealthRequest::getQuote)
					.map(HealthQuote::getPayment)
					.map(Payment::getDetails)
					.map(PaymentDetails::getType)
					.map(PaymentType::findByCode)
					.orElseThrow(() -> new SendEmailException("Failed to buildApplicationEmailModel: PaymentType not set"));

			JSONObject pricing = getJsonObject(productJSON, "price", 0)
					.flatMap(j -> getJsonObject(j, "paymentTypePremiums"))
					.flatMap(j -> getJsonObject(j, ResponseAdapterV2.getPaymentType(paymentType)))
					.flatMap(j -> getJsonObject(j, premiumFrequency))
					.orElseThrow(() -> new SendEmailException("Unable to find premium"));

			String productType = getJsonObject(productJSON, "price", 0)
					.flatMap(j -> getJsonObject(j,"info")).map(x -> {
						try {
							return x.getString("ProductType");
						} catch (JSONException ex) {
							return "";
						}
					}).orElse("");

			emailModel.setCoverType(productType);
			emailModel.setPremium(pricing.getString("text"));
			emailModel.setPremiumLabel(pricing.getString("pricing"));
			emailModel.setPremiumTotal(pricing.getString("text"));
		} catch (JSONException e) {
			throw new SendEmailException("Failed to buildApplicationEmailModel", e);
		}

		emailModel.setHealthMembership(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getSituation)
				.map(Situation::getHealthCvr)
				.map(c -> generalDao.getValuesOrdered("healthCvr").getOrDefault(c, ""))
				.orElse(""));


		emailModel.setHealthSituation(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getSituation)
				.map(Situation::getHealthSitu)
				.map(c -> generalDao.getValuesOrdered("healthSitu").getOrDefault(c, ""))
				.orElse(""));

		emailModel.setPolicyStartDate(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getPayment)
				.map(com.ctm.web.health.model.form.Payment::getDetails)
				.map(PaymentDetails::getStart)
				.orElse(""));

		emailModel.setPrimary(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getPrimary)
				.map(this::createPolicyHolderModel)
				.orElseThrow(() -> new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
						" transactionId:" +  transactionId + " missing Primary applicant")));

		emailModel.setPartner(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getPartner)
				.map(this::createPolicyHolderModel)
				.orElse(null));

		emailModel.setDependants(data.map(HealthRequest::getQuote)
				.map(HealthQuote::getApplication)
				.map(Application::getDependants)
				.map(Dependants::getDependant)
				.orElse(emptyList())
				.stream()
				.filter(d -> d != null && d.getLastname() != null)
				.map(this::createPolicyHolderModel)
				.collect(toList()));

		try {
			emailModel.setProviderEmail(providerContentService.getProviderEmail(request, providerName));
		} catch (DaoException e) {
			LOGGER.error("Exception for " + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}

		setCustomerKey(emailModel, mailingName);
		return emailModel;
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


	private HealthProductBrochuresEmailModel buildProductBrochureEmailModel(EmailMaster emailDetails, HttpServletRequest request, HealthEmailBrochureRequest emailBrochureRequest, boolean blockEmailSending) throws SendEmailException {
		HealthProductBrochuresEmailModel emailModel = new HealthProductBrochuresEmailModel();
		buildEmailModel(emailDetails, emailModel);
		String productId = request.getParameter("productId");
		String productCode = request.getParameter("productCode");
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		OpeningHoursService openingHoursService = new OpeningHoursService();
		String cid = "em:cm:health:301005";
		String utmSource = "health_pds_" + LocalDate.now().getYear();
		String utmMedium = "email";
		String utmCampaign = "health_pds";
		boolean isCallCenter = SessionUtils.isCallCentre(request.getSession());

		try {
			final Data dataBucket = sessionDataService.getDataForTransactionId(request, Long.toString(emailBrochureRequest.transactionId), false);

			if (isCallCenter && dataBucket.getString("health/simples/contactType").equals("webchat") && blockEmailSending) {
				cid = "livechat";
				utmSource = "livechat";
				utmMedium = "livechat";
				utmCampaign = "livechat";
			}

			emailModel.setPhoneNumber(getCallCentreNumber());

			emailModel.setCallcentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
			emailModel.setTransactionId(emailBrochureRequest.transactionId);
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setLastName(emailDetails.getLastName());
			emailModel.setOptIn(optedIn);

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
				emailModel.setApplyUrl(urlService.getApplyUrl(emailDetails, emailParameters, otherEmailParameters));

				emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
				emailParameters.remove(EmailUrlService.PRODUCT_ID);
				emailModel.setUnsubscribeURL(urlService.getUnsubscribeUrl(emailParameters));
			} else {
				emailModel.setApplyUrl(urlServiceOld.getApplyUrl(emailDetails, emailBrochureRequest.transactionId, "bestprice", productId, emailBrochureRequest.productName));
				emailModel.setUnsubscribeURL(urlServiceOld.getUnsubscribeUrl(emailDetails));
			}
		} catch (DaoException|EnvironmentException | VerticalException
				| ConfigSettingException | SessionException e) {
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

		emailModel.setHealthSituation(request.getParameter("healthSituation"));
		emailModel.setPrimaryCurrentPHI(request.getParameter("primaryCurrentPHI"));
		emailModel.setCoverType(request.getParameter("coverType"));
		emailModel.setBenefitCodes(request.getParameter("benefitCodes"));
		emailModel.setSpecialOffer(request.getParameter("specialOffer"));
		emailModel.setSpecialOfferTerms(request.getParameter("specialOfferTerms"));
		emailModel.setExcessPerAdmission(request.getParameter("excessPerAdmission"));
		emailModel.setExcessPerPerson(request.getParameter("excessPerPerson"));
		emailModel.setExcessPerPolicy(request.getParameter("excessPerPolicy"));
		emailModel.setCoPayment(request.getParameter("coPayment"));
		return emailModel;
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

}