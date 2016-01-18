package com.ctm.web.core.services;

/**
 *
 * Session service.
 *
 * This class is the handler for when using the session object. It contains the application logic for verifying session information.
 *
 * Note: This is should be application scoped (all methods should therefore be static)
 *
 */

import com.ctm.web.core.security.token.JwtTokenCreator;
import com.ctm.web.core.security.token.config.TokenCreatorConfig;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.utils.ResponseUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;
import java.util.function.Function;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * To use this as a singleton class we must not have any property declared on this class. Use SessionDataServiceBean instead which can
 * be autowired by spring
 */
@Deprecated
public class SessionDataService extends SessionDataServiceBean {

	private static final Logger LOGGER = LoggerFactory.getLogger(SessionDataService.class);

	private static final int SESSION_EXPIRY_DIFFERENCE = 5;
	private JwtTokenCreator tokenCreator;

	public SessionDataService(JwtTokenCreator tokenCreator) {
		this.tokenCreator = tokenCreator;
	}

	public SessionDataService() {
	}

	public Optional<String> updateToken(HttpServletRequest request)  {
		return updateToken(request, currentToken ->
				tokenCreator.refreshToken(currentToken, getClientSessionTimeoutSeconds(request) + 10));
	}

	private Optional<String> updateToken(HttpServletRequest request, final Long newTransactionId)  {
		return updateToken(request, currentVerificationToken -> {
			return tokenCreator.refreshToken(currentVerificationToken, newTransactionId , getClientSessionTimeoutSeconds(request) + 10);
		});
	}

	private Optional<String> updateToken(HttpServletRequest request, Function<String,String> createToken)  {
		Optional<String> verificationTokenMaybe;
		String currentVerificationToken = RequestUtils.getTokenFromRequest(request);
		if(currentVerificationToken != null && !currentVerificationToken.isEmpty()) {
			verificationTokenMaybe = Optional.ofNullable(createToken.apply(currentVerificationToken));
		} else {
			verificationTokenMaybe = Optional.empty();
		}
		return verificationTokenMaybe;
	}

	/**
	 * Used in access_touch.jsp
	 */
	@SuppressWarnings("unused")
	public String updateTokenWithNewTransactionIdResponse(HttpServletRequest request, String baseJsonResponse, Long newTransactionId)  {
		tokenCreator = new JwtTokenCreator( new SettingsService(request) ,  new TokenCreatorConfig());
		String output = baseJsonResponse;
		try {
			JSONObject response;
			if (baseJsonResponse != null && !baseJsonResponse.isEmpty()) {
				response = new JSONObject(baseJsonResponse);
			} else {
				response = new JSONObject();
			}
			ResponseUtils.setToken(response, updateToken(request, newTransactionId));
			output = response.toString();
		} catch (JSONException e) {
			LOGGER.error("Failed to create JSON response. {}", kv("baseJsonResponse", baseJsonResponse), e);
		}
		return output;
	}

}