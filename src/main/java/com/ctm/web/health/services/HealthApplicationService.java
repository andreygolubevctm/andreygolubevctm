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
    private final HealthPriceDao healthPriceDao;
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
                HealthCalculatedPremium premium = calculatePremiums(selectedProduct, request);
                updateDataBucket(data, premium);
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

    private HealthCalculatedPremium calculatePremiums(JSONObject selectedProduct, HealthApplicationRequest request) throws DaoException, JspException {
        HealthCalculatedPremium premium = null;

        try {
            premium = fetchHealthResult(selectedProduct, request);
        } catch (JSONException e) {
            LOGGER.error("Failed to fetched health results {}", kv("selectedProduct", selectedProduct), e);
            throw new JspException(e);
        }
        return premium;
    }

    /**
     * Fetch single health product based on product id
     */
    private HealthCalculatedPremium fetchHealthResult(JSONObject selectedProduct, HealthApplicationRequest request) throws JSONException {
        HealthCalculatedPremium healthPricePremium = new HealthCalculatedPremium();
        PaymentType paymentType = request.payment.details.paymentType;
        JSONObject priceObj = selectedProduct.getJSONArray("price").getJSONObject(0).getJSONObject("paymentTypePremiums").getJSONObject(paymentType.equals(PaymentType.BANK) ? "BankAccount" : "CreditCard");

        JSONObject payFrequencyPrice;
        switch (request.payment.details.frequency) {
            case WEEKLY:
                payFrequencyPrice = priceObj.getJSONObject("weekly");
                healthPricePremium.setPeriods(52);
                break;
            case FORTNIGHTLY:
                payFrequencyPrice = priceObj.getJSONObject("fortnightly");
                healthPricePremium.setPeriods(26);
                break;
            case QUARTERLY:
                payFrequencyPrice = priceObj.getJSONObject("quarterly");
                healthPricePremium.setPeriods(4);
                break;
            case HALF_YEARLY:
                payFrequencyPrice = priceObj.getJSONObject("halfyearly");
                healthPricePremium.setPeriods(2);
                break;
            case ANNUALLY:
                payFrequencyPrice = priceObj.getJSONObject("annually");
                healthPricePremium.setPeriods(1);
                break;
            default:
                payFrequencyPrice = priceObj.getJSONObject("monthly");
                healthPricePremium.setPeriods(12);
        }

        healthPricePremium.setHospitalValue(Double.parseDouble(payFrequencyPrice.getString("hospitalValue").replace("$", "").replace(",","")));
        healthPricePremium.setGrossPremium(Double.parseDouble(payFrequencyPrice.getString("grossPremium").replace("$", "").replace(",","")));
        healthPricePremium.setPaymentValue(Double.parseDouble(payFrequencyPrice.getString("value").replace("$", "").replace(",","")));
        healthPricePremium.setDiscountValue(Double.parseDouble(payFrequencyPrice.getString("discountAmount").replace("$", "").replace(",","")));
        healthPricePremium.setDiscountPercentage(Double.parseDouble(payFrequencyPrice.getString("discountPercentage").replace("$", "").replace(",","")));
        healthPricePremium.setLhcValue(Double.parseDouble(payFrequencyPrice.getString("lhc").replace("$", "").replace(",","")));

        healthPricePremium.setRebateValue(Double.parseDouble(payFrequencyPrice.getString("rebateValue").replace("$", "").replace(",","")));

        return healthPricePremium;
    }

    private void updateDataBucket(Data data, HealthCalculatedPremium premium) {

        data.put("health/application/paymentHospital", premium.getHospitalValue() * premium.getPeriods());
        data.put("health/application/grossPremium", premium.getGrossPremium() * premium.getPeriods());
        data.putDouble("health/application/paymentAmt", premium.getPaymentValue() * premium.getPeriods());
        data.put("health/application/paymentFreq", premium.getPaymentValue());
        data.put("health/application/discountAmt", premium.getDiscountValue() * premium.getPeriods());
        data.put("health/application/discount", premium.getDiscountPercentage());
        data.put("health/loadingAmt", premium.getLhcValue() * premium.getPeriods());
        data.put("health/rebateAmt", premium.getRebateValue());

        data.putInteger("healthCover/income", request.income);

        // TODO: this is a FIX frequency value to legacy so outbound soap messages work.
        // Refactor so that we aren't swapping this around. The actual value coming from the form is
        // request.frequency.getDescription()
        data.put(PREFIX + "/payment/details/frequency", request.payment.details.frequency.getCode());
        data.putDouble(PREFIX + "/application/paymentFreq", premium.getPaymentValue());
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
