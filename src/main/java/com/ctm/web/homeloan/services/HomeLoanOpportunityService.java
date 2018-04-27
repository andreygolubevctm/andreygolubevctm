package com.ctm.web.homeloan.services;

import com.ctm.web.core.connectivity.JsonConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.homeloan.model.HomeLoanModel;
import com.ctm.web.homeloan.model.HomeLoanOpportunityProduct;
import com.ctm.web.homeloan.model.HomeLoanOpportunityRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HomeLoanOpportunityService {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeLoanOpportunityService.class);
	public static final String SECRET_KEY = "kD0axgKXQ5HixuWsJ8-2BA";
	private String transactionId;
	private String sessionId;
	private int styleCodeId;

	public JSONObject submitOpportunity(HttpServletRequest request, HomeLoanModel model) {
		transactionId = request.getParameter("transactionId") != null ? request.getParameter("transactionId") : "0";
		sessionId = request.getSession() != null ? request.getSession().getId() : "";
		try {
			Brand brand = ApplicationService.getBrandFromRequest(request);
			styleCodeId = brand.getId();
		}
		catch (DaoException daoE) {}
		List<SchemaValidationError> errors = FormValidation.validate(model, "homeloan");
		if(errors.isEmpty()){
			return  submit(request, model);
		} else {
			FormValidation.logErrors(sessionId, transactionId, styleCodeId, errors , "HomeLoanOpportunityService:submitOpportunity");
			return FormValidation.outputToJson(transactionId , errors);
		}
	}

	private JSONObject submit(HttpServletRequest request, HomeLoanModel model) {
		JSONObject responseJson = null;
		// Product model
		HomeLoanOpportunityProduct product = new HomeLoanOpportunityProduct();
		if(model.getProductId() != null) {
            product.setFlexId(model.getProductId());
        }
		if(model.getRepaymentOption() != null) {
            product.setRepaymentOption(model.getRepaymentOption());
        }
		product.setSelected(true);
		product.setIntegrationId(Long.toString(new Date().getTime()));

		// The request model
		HomeLoanOpportunityRequest hlorModel = new HomeLoanOpportunityRequest();
		hlorModel.setReferenceId(Long.toString(model.getTransactionId()));
		String name = "";
		if (model.getContactFirstName() == null || model.getContactFirstName().length() == 0) {
            name = "UnknownFirstName ";
        }
        else {
            name = model.getContactFirstName() + " ";
        }
		if (model.getContactSurname() == null || model.getContactSurname().length() == 0) {
            name += "UnknownSurname";
        }
        else {
            name += model.getContactSurname();
        }
		hlorModel.setOpportunityDescription(name);
		hlorModel.setModel(model);
		hlorModel.addProduct(product);
		responseJson = doSubmit(request, hlorModel);
		return responseJson;
	}

	private JSONObject doSubmit(HttpServletRequest request, HomeLoanOpportunityRequest hlorModel) {
		JSONObject responseJson;
		try {
            //
            // Get the configuration
            //
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationForContext(request, "appService");

            if (serviceConfig == null) {
                throw new Exception("Unable to find service 'appService'");
            }

            String serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, Scope.SERVICE);
            String timeoutConnect = serviceConfig.getPropertyValueByKey("timeoutConnect", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, Scope.SERVICE);
            String timeoutRead = serviceConfig.getPropertyValueByKey("timeoutRead", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, Scope.SERVICE);

            if (serviceUrl == null) {
                throw new Exception("Unable to find service configuration for 'serviceUrl'");
            }
            if (timeoutConnect == null) {
                throw new Exception("Unable to find service configuration for 'timeoutConnect'");
            }
            if (timeoutRead == null) {
                throw new Exception("Unable to find service configuration for 'timeoutRead'");
            }
			responseJson = executeFetch(hlorModel, serviceUrl, timeoutConnect, timeoutRead);
			responseJson = handleExternalServiceResponse(responseJson);
		}
		catch (Exception e) {
			String message = (e.getMessage() != null ? e.getMessage() : "Failed to submit");
			FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);
			LOGGER.error("Opportunity submit failed {}", kv("hlorModel", hlorModel), e);
			responseJson = createErrorResponse(message);
		}
		return responseJson;
	}

	private JSONObject executeFetch(HomeLoanOpportunityRequest hlorModel, String serviceUrl, String timeoutConnect, String timeoutRead) {
		JsonConnection jsonConn = new JsonConnection();
		jsonConn.conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
		jsonConn.conn.setReadTimeout(Integer.parseInt(timeoutRead));
		jsonConn.conn.setContentType("application/json");

		String postBody = hlorModel.toJsonObject().toString();
		LOGGER.info("Opportunity submit details {}, {}", kv("serviceUrl", serviceUrl), kv("postBody", postBody));
		return jsonConn.post(serviceUrl, postBody);
	}


	private JSONObject createErrorResponse(String message) {
		JSONObject responseJson;
		Error error = new Error();
		error.addError(new Error(message));
		responseJson = error.toJsonObject(true);
		return responseJson;
	}

	private JSONObject handleExternalServiceResponse(JSONObject responseJson) throws JSONException {
		if (responseJson != null) {
			LOGGER.debug("Opportunity response {}", kv("responseJson", responseJson));
		}
		//
		// Check that response is ok
		//
		if (responseJson == null) {
			responseJson = createErrorResponse("Post to external service failed");
        }
        else if (!responseJson.has("responseData") || responseJson.isNull("responseData")) {
            String message = "Failed to submit";

            // Check if we can get the error reason
            if (responseJson.has("errorData") && !responseJson.isNull("errorData")) {
                JSONObject errorData = responseJson.getJSONObject("errorData");
                if (errorData.has("processErrors") && !errorData.isNull("processErrors")) {
                    JSONArray processErrors = errorData.getJSONArray("processErrors");
                    if (processErrors.length() > 0) {
                        message = processErrors.getString(0);
                    }
                }
            }
			responseJson = createErrorResponse(message);
        }
		return responseJson;
	}

	public static String getSecretKey() {
		return SECRET_KEY;
	}
}
