package com.ctm.web.homeloan.services;

import com.ctm.web.core.connectivity.JsonConnection;
import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.homeloan.model.HomeLoanProductSearchRequest;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.web.go.Data;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class HomeLoanResultsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(HomeLoanResultsService.class);

	private static BigDecimal months = new BigDecimal("12");
	private static BigDecimal fortnights = new BigDecimal("26");
	private static BigDecimal weeks = new BigDecimal("52");
	private static int ROUNDING_MODE = BigDecimal.ROUND_HALF_UP;
	private Data dataBucket;


	/**
	 * Perform a search using the request parameters.
	 * @param request
	 * @return
	 */
	public JSONObject getResults(HttpServletRequest request) {
		HomeLoanProductSearchRequest hlpsrModel = new HomeLoanProductSearchRequest();
		hlpsrModel.setModel(HomeLoanService.mapParametersToModel(request));
		return getResults(request, hlpsrModel);
	}

	/**
	 * Perform a search using the request model.
	 * @param request Required to look up service configuration
	 * @param hlpsrModel Model with necessary search parameters
	 * @return
	 */
	public JSONObject getResults(HttpServletRequest request, HomeLoanProductSearchRequest hlpsrModel) {
		JSONObject responseJson = null;

		try {
			//
			// Get the configuration
			//
			ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationForContext(request, "quoteService");

			if (serviceConfig == null) {
				throw new Exception("Unable to find service 'quoteService'");
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

			String postBody = hlpsrModel.toJsonObject().toString();
			LOGGER.trace("homeloan results {}, {}, {}, {}", kv("timeoutConnect", timeoutConnect), kv("timeoutRead", timeoutRead), kv("serviceUrl", serviceUrl), kv("postBody", postBody));

			responseJson = jsonConn.post(serviceUrl, postBody);

			if (responseJson != null) {
				LOGGER.trace("homeloan response {}", kv("responseJson", responseJson));
			}

			//
			// Check that response is ok
			//
			if (responseJson == null) {
				throw new Exception("Get from external service failed");
			}
			else if (!responseJson.has("responseData") || responseJson.isNull("responseData")) {
				String message = "Failed to get results";
				throw new Exception(message);
			}
			else {
				//
				// Calculate if there are more results
				//
				int remainingProducts = 0;

				if (responseJson.has("responseData")) {
					JSONObject data = responseJson.getJSONObject("responseData");
					if (data.has("totalCount") && !data.isNull("totalCount")) {
						int totalCount = data.getInt("totalCount");
						remainingProducts = totalCount - (hlpsrModel.getModel().getPageNumber() * 10);

						if (remainingProducts < 0) remainingProducts = 0;
					}
				}

				JSONObject events = new JSONObject();
				events.put("HOMELOAN_RESULTS_REMAINING_PRODUCTS", remainingProducts);

				JSONObject info = new JSONObject();
				dataBucket = (Data) request.getAttribute("data");
				info.put("trackingKey", (String) dataBucket.get("homeloan/trackingKey"));

				JSONObject results = new JSONObject();
				results.put("events", events);
				results.put("info", info);

				responseJson.put("results", results);

				//
				// Calculate other repayment frequencies
				//
				if (responseJson.has("responseData")) {
					JSONObject data = responseJson.getJSONObject("responseData");
					if (data.has("searchResults") && !data.isNull("searchResults")) {
						JSONArray searchResults = data.getJSONArray("searchResults");
						if (searchResults != null) {
							for (int i = 0; i < searchResults.length(); i++) {
								JSONObject result = searchResults.getJSONObject(i);
								if (result.has("monthlyRepayments")) {
									int monthlyValue = result.getInt("monthlyRepayments");

									BigDecimal monthly = new BigDecimal(monthlyValue);
									BigDecimal yearly = monthly.multiply(months);
									BigDecimal fortnightly = yearly.divide(fortnights, 0, ROUNDING_MODE);
									BigDecimal weekly = yearly.divide(weeks, 0, ROUNDING_MODE);

									result.put("fortnightlyRepayments", fortnightly);
									result.put("weeklyRepayments", weekly);
								}
							}
						}
					}
				}
			}
		}
		catch (Exception e) {
			String sessionId = "";
			int styleCodeId = 0;
			String transactionId = "";

			if (request.getSession() != null) sessionId = request.getSession().getId();
			if (request.getParameter("transactionId") != null) transactionId = request.getParameter("transactionId");

			try {
				Brand brand = ApplicationService.getBrandFromRequestStatic(request);
				styleCodeId = brand.getId();
			}
			catch (DaoException daoE) {}

			FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);

			LOGGER.error("homeloan results failed {}", kv("hlpsrModel", hlpsrModel), e);

			String message = (e.getMessage() != null ? e.getMessage() : "Failed to get results");
			Error error = new Error();
			error.addError(new Error(message));
			responseJson = error.toJsonObject(true);
		}

		return responseJson;
	}

}
