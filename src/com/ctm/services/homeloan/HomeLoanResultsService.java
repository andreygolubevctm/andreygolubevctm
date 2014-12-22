package com.ctm.services.homeloan;

import java.math.BigDecimal;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.ctm.connectivity.JsonConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.homeloan.HomeLoanProductSearchRequest;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.ServiceConfigurationProperty.Scope;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.ServiceConfigurationService;
import com.disc_au.web.go.Data;

public class HomeLoanResultsService {
	private static Logger logger = Logger.getLogger(HomeLoanResultsService.class.getName());

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
			JsonConnection jsonConn = new JsonConnection();
			jsonConn.conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
			jsonConn.conn.setReadTimeout(Integer.parseInt(timeoutRead));
			jsonConn.conn.setContentType("application/json");

			String postBody = hlpsrModel.toJsonObject().toString();
			logger.debug("HomeLoanResultsService.getResults TIMEOUTCONNECT:" + timeoutConnect + " TIMEOUTREAD:" + timeoutRead + " URL:" + serviceUrl);
			logger.debug("HomeLoanResultsService.getResults POST: " + postBody); //Note: Could contain personal information

			responseJson = jsonConn.post(serviceUrl, postBody);

			if (responseJson != null) {
				logger.debug("HomeLoanResultsService.getResults RESP: " + responseJson.toString());
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

									//logger.debug(monthly + " : " + yearly + " : " + fortnightly + " : " + weekly);

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
				Brand brand = ApplicationService.getBrandFromRequest(request);
				styleCodeId = brand.getId();
			}
			catch (DaoException daoE) {}

			FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);

			logger.error("HomeLoanResultsService.getResults failed: ", e);

			String message = (e.getMessage() != null ? e.getMessage() : "Failed to get results");
			Error error = new Error();
			error.addError(new Error(message));
			responseJson = error.toJsonObject(true);
		}

		return responseJson;
	}

}
