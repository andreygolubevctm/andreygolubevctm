package com.ctm.services.utilities;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.ctm.connectivity.JsonConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.utilities.UtilitiesLeadfeedModel;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.ServiceConfigurationService;

public class UtilitiesLeadfeedService {

	private static Logger logger = Logger.getLogger(UtilitiesLeadfeedService.class.getName());

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
			JsonConnection jsonConn = new JsonConnection();
			jsonConn.conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
			jsonConn.conn.setReadTimeout(Integer.parseInt(timeoutRead));
			jsonConn.conn.setContentType("application/json");

			String postBody = model.toJsonObject().toString();
			logger.debug("UtilitiesLeadfeedService.submit TIMEOUTCONNECT:" + timeoutConnect + " TIMEOUTREAD:" + timeoutRead + " URL:" + serviceUrl);
			logger.debug("UtilitiesLeadfeedService.submit POST: " + postBody); //Note: could contain personal information

			responseJson = jsonConn.post(serviceUrl, postBody);

			if (responseJson != null) {
				logger.debug("UtilitiesLeadfeedService.submit RESP: " + responseJson.toString());
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
				Brand brand = ApplicationService.getBrandFromRequest(request);
				styleCodeId = brand.getId();
			}
			catch (DaoException daoE) {}

			FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);

			logger.error("UtilitiesLeadfeedService.submit failed: ", e);

			String message = (e.getMessage() != null ? e.getMessage() : "Failed to submit");
			Error error = new Error();
			error.addError(new Error(message));
			responseJson = error.toJsonObject(true);
		}

		return responseJson;
	}

}
