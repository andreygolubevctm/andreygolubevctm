package com.ctm.services.utilities;

import com.ctm.connectivity.JsonConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.ServiceConfigurationService;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import javax.servlet.http.HttpServletRequest;

/**
 * Common functions for the Utilities Services
 */
public class UtilitiesBaseService {

	private static Logger logger = Logger.getLogger(UtilitiesBaseService.class.getName());

	/**
	 * Simple wrapper to get a config value
	 * @param serviceConfig
	 * @param key
	 * @return
	 * @throws Exception
	 */
	private String getConfigValue(ServiceConfiguration serviceConfig, String key) throws UtilitiesWebServiceException{
		String string = serviceConfig.getPropertyValueByKey(key, ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);

		if(string == null){
			throw new UtilitiesWebServiceException("UTL: Unable to find service configuration for: "+key);
		}

		return string;
	}

	private ServiceConfiguration getServiceConfig(HttpServletRequest request, String serviceName) throws ServiceConfigurationException, DaoException, UtilitiesWebServiceException{
		ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationForContext(request, serviceName);

		if (serviceConfig == null) {
			throw new UtilitiesWebServiceException("UTL: Unable to find service: "+serviceName);
		}

		return serviceConfig;
	}

	private JsonConnection getJsonConnector(HttpServletRequest request, ServiceConfiguration serviceConfig){

		String timeoutConnect = getConfigValue(serviceConfig, "timeoutConnect");
		String timeoutRead = getConfigValue(serviceConfig, "timeoutRead");

		JsonConnection jsonConnector = new JsonConnection();
		jsonConnector.conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
		jsonConnector.conn.setReadTimeout(Integer.parseInt(timeoutRead));
		jsonConnector.conn.setContentType("application/json");

		return jsonConnector;
	}

	/**
	 * Simple method to retrieve a configured json connector object.
	 * @param request
	 * @param serviceName
	 * @return
	 * @throws Exception
	 */

	protected JSONObject postJson(HttpServletRequest request, String serviceName, String jsonString) throws ServiceConfigurationException, DaoException, UtilitiesWebServiceException{

		JSONObject responseJson = null;

		ServiceConfiguration serviceConfig = getServiceConfig(request, serviceName);

		logger.debug("UTL: POST: " + jsonString);

		String serviceUrl = getConfigValue(serviceConfig, "serviceUrl");
		JsonConnection jsonConnector = getJsonConnector(request, serviceConfig);
		responseJson = jsonConnector.post(serviceUrl, jsonString);

		logger.debug("UTL: RESP:" + responseJson);

		if (responseJson == null) {
			throw new UtilitiesWebServiceException("UTL postJson: JSON Object NULL from "+serviceUrl);
		}

		return responseJson;

	}

	protected JSONArray postJsonArray(HttpServletRequest request, String serviceName, String jsonString) throws ServiceConfigurationException, DaoException, UtilitiesWebServiceException{

		JSONArray responseJson = null;

		ServiceConfiguration serviceConfig = getServiceConfig(request, serviceName);

		logger.debug("UTL: POST: " + jsonString);

		String serviceUrl = getConfigValue(serviceConfig, "serviceUrl");
		JsonConnection jsonConnector = getJsonConnector(request, serviceConfig);
		responseJson = jsonConnector.postArray(serviceUrl, jsonString);

		logger.debug("UTL: RESP:" + responseJson);

		if (responseJson == null) {
			throw new UtilitiesWebServiceException("UTL postJson: JSON Object NULL from "+serviceUrl);
		}

		return responseJson;

	}

	/**
	 * Simple function to help with logging a fatal error to the DB.
	 * @param request
	 * @param e
	 */
	protected void recordError(HttpServletRequest request, Exception e){

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

		logger.error("UTL: Error: ", e);

	}
}
