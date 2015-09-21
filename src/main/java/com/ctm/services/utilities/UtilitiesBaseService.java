package com.ctm.services.utilities;

import com.ctm.connectivity.JsonConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.UtilitiesWebServiceException;
import com.ctm.model.request.utilities.UtilitiesRequest;
import com.ctm.model.settings.*;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import com.ctm.services.RequestService;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.utils.utilities.UtilitiesRequestParser;
import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

/**
 * Common functions for the Utilities Services
 */
public class UtilitiesBaseService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UtilitiesBaseService.class);

	private boolean valid = false;
	private String vertical = Vertical.VerticalType.UTILITIES.getCode();

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
			throw new UtilitiesWebServiceException("Unable to find service configuration for: "+key);
		}

		return string;
	}

	private ServiceConfiguration getServiceConfig(HttpServletRequest request, String serviceName) throws ServiceConfigurationException, DaoException, UtilitiesWebServiceException{
		ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfigurationForContext(request, serviceName);

		if (serviceConfig == null) {
			throw new UtilitiesWebServiceException("Unable to find service: "+serviceName);
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

		LOGGER.trace("Post {}", kv("jsonString", jsonString));

		String serviceUrl = getConfigValue(serviceConfig, "serviceUrl");
		JsonConnection jsonConnector = getJsonConnector(request, serviceConfig);
		responseJson = jsonConnector.post(serviceUrl, jsonString);

		LOGGER.trace("Response {}", kv("responseJson", responseJson));

		if (responseJson == null) {
			throw new UtilitiesWebServiceException("UTL postJson: JSON Object NULL from "+serviceUrl);
		}

		return responseJson;

	}

	protected JSONArray postJsonArray(HttpServletRequest request, String serviceName, String jsonString) throws ServiceConfigurationException, DaoException, UtilitiesWebServiceException{

		JSONArray responseJson = null;

		ServiceConfiguration serviceConfig = getServiceConfig(request, serviceName);

		LOGGER.trace("Post {}", kv("jsonString", jsonString));

		String serviceUrl = getConfigValue(serviceConfig, "serviceUrl");
		JsonConnection jsonConnector = getJsonConnector(request, serviceConfig);
		responseJson = jsonConnector.postArray(serviceUrl, jsonString);

		LOGGER.trace("Response {}", kv("responseJson", responseJson));

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

		LOGGER.error("Error occurred with utilities http post", e);

	}

	public String validate(HttpServletRequest request, Data data) {
		RequestService fromFormService = new RequestService(request, vertical, data);
		UtilitiesRequest utilitiesRequest = UtilitiesRequestParser.parseRequest(data, vertical);
		List<SchemaValidationError> errors = validate(utilitiesRequest);
		if(!valid) {
			return outputErrors(fromFormService, errors);
		}
		return "";
	}

	public List<SchemaValidationError> validate(UtilitiesRequest utilitiesRequest) {
		List<SchemaValidationError> errors = FormValidation.validate(utilitiesRequest, vertical.toLowerCase(), false);
		valid = errors.isEmpty();
		return errors;
	}

	private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
		String response;
		FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "UtilitiesBaseService.java:validate");
		response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
		return response;
	}

	public boolean isValid() {
		return valid;
	}
}
