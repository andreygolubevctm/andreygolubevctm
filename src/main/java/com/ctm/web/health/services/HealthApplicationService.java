package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.CTMEndpointService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.dao.HealthPriceDao;
import com.ctm.web.health.model.Frequency;
import com.ctm.web.health.model.HealthPricePremium;
import com.ctm.web.health.model.PaymentType;
import com.ctm.web.health.model.request.HealthApplicationRequest;
import com.ctm.web.health.price.PremiumCalculator;
import com.ctm.web.health.utils.HealthApplicationParser;
import com.ctm.web.health.utils.HealthRequestParser;
import com.ctm.web.health.validation.HealthApplicationTokenValidation;
import com.ctm.web.health.validation.HealthApplicationValidation;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import java.util.Date;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HealthApplicationService extends CTMEndpointService {

    private HealthSelectedProductService healthSelectedProductService;

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
    public static final String HEALTH_COVER_XPATH = PREFIX + "/healthCover/partner";
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
        this.healthSelectedProductService = new HealthSelectedProductService();
    }

    public HealthApplicationService(HealthPriceDao healthPriceDao, FatalErrorService fatalErrorService, HealthApplicationTokenValidation tokenService, HealthSelectedProductService healthSelectedProductService) {
        this.tokenService = tokenService;
        this.healthPriceDao = healthPriceDao;
        this.fatalErrorService = fatalErrorService;
        this.healthSelectedProductService = healthSelectedProductService;
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
                SettingsService settingsService = new SettingsService(httpRequest);
                tokenService = new HealthApplicationTokenValidation(settingsService, sessionDataService, pageSettings.getVertical());
            }
            super.validateToken(httpRequest, tokenService, HealthRequestParser.getHealthRequestToken(requestService, isCallCentre));
            request = HealthApplicationParser.parseRequest(data, changeOverDate);
            boolean isUuid = isUuid(request.application.selectedProductId);

            // This is a dirty hack to get Non HPM Products working, they are saved in the database with PHIO-HEALTH-{ID} but are sent here with just the ID
            String selectedProductJson = healthSelectedProductService.getProductXML(requestService.getTransactionId(), !isUuid ? new StringBuilder("PHIO-HEALTH-").append(request.application.selectedProductId).toString() : request.application.selectedProductId);
            JSONObject selectedProduct = null;
            try {
                selectedProduct = new JSONObject(selectedProductJson);
            } catch (JSONException e) {
                LOGGER.error("Failed to parse selected product JSON {}", kv("selectedProduct", selectedProductJson), e);
                throw new JspException(e);
            }

            HealthApplicationValidation validationService = new HealthApplicationValidation();
            validationErrors = validationService.validate(request);
            if (validationErrors.size() == 0) {
                calculatePremiums(selectedProduct, request);
                updateDataBucket(data);
            }
        } catch (DaoException | ConfigSettingException e) {
            LOGGER.error("Failed to calculate health premiums {},{}", kv("data", data), kv("changeOverDate", changeOverDate), e);
            fatalErrorService.logFatalError(e, 0, "HealthApplicationService", true, data.getString("current.transactionId"));
            throw new JspException(e);
        }
        return handleValidationResult(requestService, validationErrors);
    }

    private boolean isUuid(String uuid) {
        return uuid.matches("[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}");
    }

    private void calculatePremiums(JSONObject selectedProduct, HealthApplicationRequest request) throws DaoException, JspException {
        Frequency frequency = request.payment.details.frequency;
        HealthPricePremium premium = null;

        try {
            premium = fetchHealthResult(selectedProduct, request);
        } catch (JSONException e) {
            LOGGER.error("Failed to fetched health results {}", kv("selectedProduct", selectedProduct), e);
            throw new JspException(e);
        }

        premiumCalculator.setRebate(request.rebateValue);
        premiumCalculator.setLoading(request.loading);
        premiumCalculator.setMembership(request.membership);

        switch (frequency) {
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
    private HealthPricePremium fetchHealthResult(JSONObject selectedProduct, HealthApplicationRequest request) throws JSONException {
        HealthPricePremium healthPricePremium = new HealthPricePremium();
        PaymentType paymentType = request.payment.details.paymentType;

        JSONObject priceObj = selectedProduct.getJSONArray("price").getJSONObject(0).getJSONObject("paymentTypePremiums").getJSONObject(paymentType.equals(PaymentType.BANK) ? "BankAccount" : "CreditCard");

        JSONObject weeklyPrice = priceObj.getJSONObject("weekly");
        healthPricePremium.setWeeklyLhc(Double.parseDouble(weeklyPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setWeeklyPremium(Double.parseDouble(weeklyPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossWeeklyPremium(Double.parseDouble(weeklyPrice.getString("grossPremium").replace("$", "").replace(",","")));

        JSONObject fortnightlyPrice = priceObj.getJSONObject("fortnightly");
        healthPricePremium.setFortnightlyLhc(Double.parseDouble(fortnightlyPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setFortnightlyPremium(Double.parseDouble(fortnightlyPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossFortnightlyPremium(Double.parseDouble(fortnightlyPrice.getString("grossPremium").replace("$", "").replace(",","")));

        JSONObject monthlyPrice = priceObj.getJSONObject("monthly");
        healthPricePremium.setMonthlyLhc(Double.parseDouble(monthlyPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setMonthlyPremium(Double.parseDouble(monthlyPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossMonthlyPremium(Double.parseDouble(monthlyPrice.getString("grossPremium").replace("$", "").replace(",","")));

        JSONObject quarterlyPrice = priceObj.getJSONObject("quarterly");
        healthPricePremium.setQuarterlyLhc(Double.parseDouble(quarterlyPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setQuarterlyPremium(Double.parseDouble(quarterlyPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossQuarterlyPremium(Double.parseDouble(quarterlyPrice.getString("grossPremium").replace("$", "").replace(",","")));

        JSONObject halfyearlyPrice = priceObj.getJSONObject("halfyearly");
        healthPricePremium.setHalfYearlyLhc(Double.parseDouble(halfyearlyPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setHalfYearlyPremium(Double.parseDouble(halfyearlyPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossHalfYearlyPremium(Double.parseDouble(halfyearlyPrice.getString("grossPremium").replace("$", "").replace(",","")));

        JSONObject annualPrice = priceObj.getJSONObject("annually");
        healthPricePremium.setAnnualLhc(Double.parseDouble(annualPrice.getString("lhc").replace("$", "").replace(",","")));
        healthPricePremium.setAnnualPremium(Double.parseDouble(annualPrice.getString("base").replace("$", "").replace(",","")));
        healthPricePremium.setGrossAnnualPremium(Double.parseDouble(annualPrice.getString("grossPremium").replace("$", "").replace(",","")));

        return healthPricePremium;
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
        data.put("health/rebateAmt", premiumCalculator.getRebateAmount());

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
        if (validationErrors.isEmpty()) {
            valid = true;
            return null;
        } else {
            valid = false;
            FormValidation.logErrors(requestService.sessionId, requestService.transactionId, requestService.styleCodeId, validationErrors, "com.ctm.health.services.HealthApplicationService:setUpApplication");
            return FormValidation.outputToJson(requestService.transactionId, validationErrors);
        }
    }

    public boolean isValid() {
        return valid;
    }

    public void setRequestService(RequestService requestService) {
        this.requestService = requestService;
    }


    public String createTokenValidationFailedResponse(Long transactionId, String sessionId) {
        try {
            return createFailedResponseObject(transactionId, sessionId, "Token Validation").toString();
        } catch (JSONException e) {
            LOGGER.error("failed to create Response");
        }
        return "";
    }

    public String createFailedResponse(Long transactionId, String sessionId) {
        try {
            JSONObject response = createFailedResponseObject(transactionId, sessionId, "Failed Application");
            appendValuesToResponse(response, transactionId);
            return response.toString();
        } catch (JSONException e) {
            LOGGER.error("failed to create Response");
        }
        return "";
    }

    private JSONObject createFailedResponseObject(Long transactionId, String sessionId, String reason) throws JSONException {
        JSONObject response = new JSONObject();
        JSONObject result = new JSONObject();
        response.put("result", result);
        result.put("success", false);
        JSONObject errors = new JSONObject();
        result.put("errors", errors);
        JSONObject error = new JSONObject();
        error.put("code", reason);
        error.put("original", reason);
        errors.put("error", error);
        String pendingId = sessionId + "-" + transactionId;
        result.put("pendingID", pendingId);
        if (isCallCentre) {
            result.put("callcentre", true);
        }
        return response;
    }


    public List<Provider> getAllProviders(int styleCodeId) throws DaoException {
        return healthPriceDao.getAllProviders(styleCodeId);
    }
}