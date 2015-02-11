package com.ctm.services.homeloan;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.connectivity.JsonConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.homeloan.HomeLoanModel;
import com.ctm.model.homeloan.HomeLoanOpportunityProduct;
import com.ctm.model.homeloan.HomeLoanOpportunityRequest;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.ServiceConfigurationService;

public class HomeLoanOpportunityService {

	private static Logger logger = Logger.getLogger(HomeLoanOpportunityService.class.getName());
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
			logger.error("HomeLoanOpportunityService.submit failed: ", e);
			responseJson = createErrorResponse(message);
		}
		return responseJson;
	}

	private JSONObject executeFetch(HomeLoanOpportunityRequest hlorModel, String serviceUrl, String timeoutConnect, String timeoutRead) {
		JSONObject responseJson;JsonConnection jsonConn = new JsonConnection();
		jsonConn.conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
		jsonConn.conn.setReadTimeout(Integer.parseInt(timeoutRead));
		jsonConn.conn.setContentType("application/json");

		String postBody = hlorModel.toJsonObject().toString();
		logger.debug("HomeLoanOpportunityService.submit TIMEOUTCONNECT:" + timeoutConnect + " TIMEOUTREAD:" + timeoutRead + " URL:" + serviceUrl);
		logger.debug("HomeLoanOpportunityService.submit POST: " + postBody); //Note: could contain personal information

		responseJson = jsonConn.post(serviceUrl, postBody);
		return responseJson;
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
			logger.debug("HomeLoanOpportunityService.submit RESP: " + responseJson.toString());
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
