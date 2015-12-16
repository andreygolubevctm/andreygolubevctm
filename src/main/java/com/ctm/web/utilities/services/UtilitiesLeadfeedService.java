package com.ctm.web.utilities.services;

import com.ctm.web.core.connectivity.JsonConnection;
import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.utilities.model.UtilitiesLeadfeedModel;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class UtilitiesLeadfeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UtilitiesLeadfeedService.class);

	public static UtilitiesLeadfeedModel mapParametersToModel(HttpServletRequest request) {

		UtilitiesLeadfeedModel model = new UtilitiesLeadfeedModel();

		String value;

		value = request.getParameter("transactionId");
		if (value != null && value.length() > 0) {
			model.setTransactionId(Long.parseLong(value));
		}

		value = request.getParameter("utilities_leadFeed_firstName");
		if (value != null && value.length() > 0) {
			model.setFirstName(value);
		}
		value = request.getParameter("utilities_leadFeed_lastName");
		if (value != null && value.length() > 0) {
			model.setLastName(value);
		}

		value = request.getParameter("utilities_leadFeed_mobileNumber");
		if (value != null && value.length() > 0) {
			model.setMobile(value);
		}

		value = request.getParameter("utilities_leadFeed_otherPhoneNumber");
		if (value != null && value.length() > 0) {
			model.setHomePhone(value);
		}

		value = request.getParameter("utilities_leadFeed_postcode");
		if (value != null && value.length() > 0) {
			model.setPostcode(value);
		}

		value = request.getParameter("utilities_leadFeed_email");
		if (value != null && value.length() > 0) {
			model.setEmail(value);
		}

		return model;
	}

	public JSONObject submit(HttpServletRequest request, UtilitiesLeadfeedModel model) {
		JSONObject responseJson = null;

		// Do submit //////////////////////////////////////////////////////////////////////////////////

		try {
			//
			// Get the configuration
			//
			ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationForContext(request, "leadfeedService");

			if (serviceConfig == null) {
				throw new Exception("Unable to find service 'leadfeedService'");
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

			//
			// Execute the fetch
			//
			SimpleConnection conn = new SimpleConnection();
			JsonConnection jsonConn = new JsonConnection(conn);
			conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
			conn.setReadTimeout(Integer.parseInt(timeoutRead));
			conn.setContentType("application/json");

			String postBody = model.toJsonObject().toString();
			LOGGER.debug("Lead feed submit {},{},{}", kv("timeoutConnect", timeoutConnect), kv("timeoutRead", timeoutRead), kv("url", serviceUrl));
			LOGGER.trace("Lead feed submit request {}", kv("request", postBody)); //Note: could contain personal information

			responseJson = jsonConn.post(serviceUrl, postBody);

			if (responseJson != null) {
				LOGGER.trace("Lead feed submit response {}", kv("response", responseJson));
			}

			//
			// Check that response is ok
			//
			if (responseJson == null) {
				throw new Exception("Post to external service failed");
			}
			else if (!responseJson.has("unique_id") || responseJson.isNull("unique_id")) {
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

				throw new Exception(message);
			}
		}
		catch (Exception e) {
			int styleCodeId = 0;


			String sessionId = request.getSession() != null ? request.getSession().getId() : "";
			String transactionId = request.getParameter("transactionId") != null ? request.getParameter("transactionId") : "0";

			try {
				Brand brand = ApplicationService.getBrandFromRequestStatic(request);
				styleCodeId = brand.getId();
			}
			catch (DaoException daoE) {}

			FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);

			LOGGER.error("Error submitting lead feed {}", kv("utilitiesLeadfeedModel", model), e);

			String message = (e.getMessage() != null ? e.getMessage() : "Failed to submit");
			Error error = new Error();
			error.addError(new Error(message));
			responseJson = error.toJsonObject(true);
		}

		return responseJson;
	}

}
