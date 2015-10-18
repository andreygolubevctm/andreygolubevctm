package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Provider;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.HealthPricePremium;
import com.ctm.model.request.health.HealthApplicationRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.*;
import com.ctm.utils.SessionUtils;
import com.ctm.utils.health.HealthApplicationParser;
import com.ctm.utils.health.HealthRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.ctm.web.validation.health.HealthApplicationTokenValidation;
import com.ctm.web.validation.health.HealthApplicationValidation;
import com.disc_au.price.health.PremiumCalculator;
import com.disc_au.web.go.Data;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import java.util.Date;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public class HealthApplicationService extends CTMEndpointService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplicationService.class);
	private final FatalErrorService fatalErrorService;

	private HealthApplicationRequest request = new HealthApplicationRequest();
	private final PremiumCalculator premiumCalculator = new PremiumCalculator();
	private final HealthPriceDao healthPriceDao;
	private int periods;
	private static final String PREFIX = "health";
	private static final String REBATE_XPATH = PREFIX + "/healthCover/rebate";
	public static final String MEDICARE_NUMBER_XPATH = PREFIX + "/payment/medicare/number";
	public static final String REBATE_HIDDEN_XPATH = PREFIX + "/rebate";
	public static final String LOADING_XPATH = PREFIX + "/loading";
	private boolean valid;
	private boolean isCallCentre;
	private RequestService requestService;

	/**
	 * used by health_application.jsp
	 */
	@SuppressWarnings("unused")
	public HealthApplicationService() {
		this.healthPriceDao = new HealthPriceDao();
		this.fatalErrorService = new FatalErrorService();
	}

	public HealthApplicationService(HealthPriceDao healthPriceDao, FatalErrorService fatalErrorService, HealthApplicationTokenValidation tokenService) {
		this.tokenService = tokenService;
		this.healthPriceDao = healthPriceDao;
		this.fatalErrorService = fatalErrorService;
	}

	public JSONObject setUpApplication(Data data, HttpServletRequest httpRequest, Date changeOverDate) throws JspException {
		// TODO: refactor this when are away from jsp
		if (requestService == null) {
			requestService = new RequestService(httpRequest, Vertical.VerticalType.HEALTH);
		} else {
			requestService.setRequest(httpRequest);
		}
		SessionDataService sessionDataService = new SessionDataService();
		isCallCentre = SessionUtils.isCallCentre(httpRequest.getSession());
		List<SchemaValidationError> validationErrors;
		try {

			if (tokenService == null) {
				PageSettings pageSettings = SettingsService.getPageSettingsForPage(httpRequest);
				SettingsService  settingsService = new SettingsService(httpRequest);
				tokenService = new HealthApplicationTokenValidation(settingsService, sessionDataService, pageSettings.getVertical());
			}
			super.validateToken(httpRequest, tokenService, HealthRequestParser.getHealthRequestToken(requestService, isCallCentre));
			request = HealthApplicationParser.parseRequest(data, changeOverDate);
			HealthApplicationValidation validationService = new HealthApplicationValidation();
			validationErrors = validationService.validate(request);
			if(validationErrors.size() == 0){
				calculatePremiums();
				updateDataBucket(data);
			}
		} catch (DaoException | ConfigSettingException e) {
			LOGGER.error("Failed to calculate health premiums {},{}", kv("data", data), kv("changeOverDate", changeOverDate), e);
			fatalErrorService.logFatalError(e, 0, "HealthApplicationService", true, data.getString("current.transactionId"));
			throw new JspException(e);
		}
		return handleValidationResult(requestService, validationErrors);
	}

	private void calculatePremiums() throws DaoException {
		Frequency frequency = request.payment.details.frequency;
		HealthPricePremium premium = fetchHealthResult();

		premiumCalculator.setRebate(request.rebateValue);
		premiumCalculator.setLoading(request.loading);
		premiumCalculator.setMembership(request.membership);

		switch(frequency){
			case WEEKLY:
				setUpPremiumCalculator(premium.getWeeklyPremium(), premium.getGrossWeeklyPremium(), premium.getWeeklyLhc());
				periods = 52;
				break;
			case FORTNIGHTLY:
				setUpPremiumCalculator(premium.getFortnightlyPremium(), premium.getGrossFortnightlyPremium(), premium.getFortnightlyLhc());
				periods = 26;
				break;
			case QUARTERLY:
				setUpPremiumCalculator(premium.getQuarterlyPremium(), premium.getGrossQuarterlyPremium(), premium.getQuarterlyLhc());
				periods = 4;
				break;
			case HALF_YEARLY:
				setUpPremiumCalculator(premium.getHalfYearlyPremium(), premium.getGrossHalfYearlyPremium(), premium.getHalfYearlyLhc());
				periods = 2;
				break;
			case ANNUALLY:
				setUpPremiumCalculator(premium.getAnnualPremium(), premium.getGrossAnnualPremium(), premium.getAnnualLhc());
				periods = 1;
				break;
			default:
				setUpPremiumCalculator(premium.getMonthlyPremium(), premium.getGrossMonthlyPremium(), premium.getMonthlyLhc());
				periods = 12;
		}

	}

	/**
	 * Fetch single health product based on product id
	 */
	private HealthPricePremium fetchHealthResult() throws DaoException {
		boolean isDiscountRates = HealthPriceService.hasDiscountRates(request.payment.details.frequency, request.application.provider, request.payment.details.paymentType, false);
		return healthPriceDao.getPremiumAndLhc(request.application.selectedProductId, isDiscountRates);
	}

	private void setUpPremiumCalculator(double premium, double grossPremium, double lhc) {
		premiumCalculator.setLhc(lhc);
		premiumCalculator.setBasePremium(premium);
		premiumCalculator.setGrossPremium(grossPremium);

	}

	private void updateDataBucket(Data data) {
		double paymentAmt = premiumCalculator.getPremiumWithRebateAndLHC();

		data.put("health/application/paymentHospital", premiumCalculator.getLhc() * periods);
		data.put("health/application/grossPremium", premiumCalculator.getGrossPremium() * periods);
		data.putDouble(PREFIX + "/application/paymentAmt", paymentAmt * periods);
		data.put("health/application/paymentFreq", paymentAmt);
		data.put("health/application/discountAmt", premiumCalculator.getDiscountValue() * periods);
		data.put("health/application/discount", premiumCalculator.getDiscountPercentage());
		data.put("health/loadingAmt", premiumCalculator.getLoadingAmount() * periods);
		data.put("health/rebateAmt", premiumCalculator.getRebateAmount() * periods);

		data.putInteger("healthCover/income", request.income);

		// TODO: this is a FIX frequency value to legacy so outbound soap messages work.
		// Refactor so that we aren't swapping this around. The actual value coming from the form is
		// request.frequency.getDescription()
		data.put(PREFIX + "/payment/details/frequency", request.payment.details.frequency.getCode());
		data.putDouble(PREFIX + "/application/paymentFreq", paymentAmt);
		data.putDouble(REBATE_HIDDEN_XPATH, request.rebateValue);
		data.putDouble(LOADING_XPATH, request.loadingValue);
		data.put(REBATE_XPATH, request.hasRebate ? "Y" : "N");

	}

	private JSONObject handleValidationResult(RequestService requestService, List<SchemaValidationError> validationErrors) {
		if(validationErrors.isEmpty()) {
			valid = true;
			return null;
		} else {
			valid = false;
			FormValidation.logErrors(requestService.sessionId, requestService.transactionId, requestService.styleCodeId, validationErrors, "com.ctm.services.health.HealthApplicationService:setUpApplication");
			return FormValidation.outputToJson(requestService.transactionId , validationErrors);
		}
	}

	public boolean isValid(){
		return valid;
	}

	public void setRequestService(RequestService requestService) {
		this.requestService = requestService;
	}


	public String createTokenValidationFailedResponse(Long transactionId, String sessionId) {
		String responseString = "";
		try {
			JSONObject response = new JSONObject();
			response.put("success", false);
			JSONObject error = new JSONObject();
			response.put("error", error);
			error.put("code", "Token Validation");
			error.put("original", "Token Validation");
			String pendingId = sessionId + "-" + transactionId;
			response.put("pendingID", pendingId);
			if(isCallCentre) {
				response.put("callcentre", true);
			}
			responseString = response.toString();
		} catch (JSONException e) {
			LOGGER.warn("Failed to create response. ", e);
		}
		return responseString;
	}

	public List<Provider> getAllProviders(int styleCodeId) throws DaoException {
		return healthPriceDao.getAllProviders(styleCodeId);
	}
}
