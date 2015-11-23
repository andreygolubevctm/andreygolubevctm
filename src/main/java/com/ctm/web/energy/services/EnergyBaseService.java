package com.ctm.web.energy.services;

import com.ctm.energy.quote.request.model.EnergyQuoteRequest;
import com.ctm.energy.quote.response.model.EnergyResultsResponse;
import com.ctm.web.core.connectivity.JsonConnection;
import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.*;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.CommonRequestService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.validation.FormValidation;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.utilities.exceptions.UtilitiesWebServiceException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;

/**
 * Common functions for the Utilities Services
 */
public class EnergyBaseService extends CommonRequestService<EnergyQuoteRequest,EnergyResultsResponse> {

	private static final Logger LOGGER = LoggerFactory.getLogger(EnergyBaseService.class);

	private boolean valid = false;
	private static final String vertical = Vertical.VerticalType.ENERGY.getCode();

	public EnergyBaseService(ProviderFilterDao providerFilterDAO, ObjectMapper objectMapper) {
		super(providerFilterDAO, objectMapper);
	}

	/**
	 * Simple wrapper to get a config value
	 * @param serviceConfig
	 * @param key
	 * @return
	 * @throws Exception
	 */
	private String getConfigValue(ServiceConfiguration serviceConfig, String key) throws UtilitiesWebServiceException {
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

	private JsonConnection getJsonConnector(ServiceConfiguration serviceConfig){

		String timeoutConnect = getConfigValue(serviceConfig, "timeoutConnect");
		String timeoutRead = getConfigValue(serviceConfig, "timeoutRead");

		SimpleConnection conn = new SimpleConnection();
		JsonConnection jsonConnector = new JsonConnection(conn);
		conn.setConnectTimeout(Integer.parseInt(timeoutConnect));
		conn.setReadTimeout(Integer.parseInt(timeoutRead));
		conn.setContentType("application/json");

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

		JSONObject responseJson;

		ServiceConfiguration serviceConfig = getServiceConfig(request, serviceName);

		LOGGER.trace("Post {}", kv("jsonString", jsonString));

		String serviceUrl = getConfigValue(serviceConfig, "serviceUrl");
		JsonConnection jsonConnector = getJsonConnector(serviceConfig);
		responseJson = jsonConnector.post(serviceUrl, jsonString);

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
		catch (DaoException daoE) {
			LOGGER.error("Failed to get brand", e);
		}

		FatalErrorService.logFatalError(e, styleCodeId, request.getRequestURI(), sessionId, false, transactionId);

		LOGGER.error("Error occurred with utilities http post", e);

	}

	public List<SchemaValidationError> validate(EnergyResultsWebRequest utilitiesRequest) {
		List<SchemaValidationError> errors = FormValidation.validate(utilitiesRequest, vertical.toLowerCase(), false);
		valid = errors.isEmpty();
		return errors;
	}


	public boolean isValid() {
		return valid;
	}
}
