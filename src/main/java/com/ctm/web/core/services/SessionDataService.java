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

import com.ctm.web.core.exceptions.BrandException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.security.token.JwtTokenCreator;
import com.ctm.web.core.security.token.config.TokenCreatorConfig;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.utils.ResponseUtils;
import com.ctm.web.core.web.go.Data;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Optional;
import java.util.function.Function;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class SessionDataService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SessionDataService.class);

	private static final int SESSION_EXPIRY_DIFFERENCE = 5;
	private JwtTokenCreator tokenCreator;

	public SessionDataService(JwtTokenCreator tokenCreator) {
		this.tokenCreator = tokenCreator;
	}

	public SessionDataService() {
	}

	/**
	 * Return the authenticated session from the session object.
	 *
	 * @param request
	 */
	public AuthenticatedData getAuthenticatedSessionData(HttpServletRequest request) {
		SessionData sessionData = getSessionDataFromSession(request);
		if (sessionData != null) {
			return sessionData.getAuthenticatedSessionData();
		} else {
			return null;
		}
	}

	public void resetAuthenticatedSessionData(HttpServletRequest request) {
		SessionData sessionData = getSessionDataFromSession(request);
		if(sessionData != null) {
			sessionData.resetAuthenticatedSessionData();
		}
	}

	/**
	 * Get the SessionData object from an HTTP session.
	 *
	 * @param request
	 */
	public SessionData getSessionDataFromSession(HttpServletRequest request) {
		return getSessionDataFromSession(request, true);
	}

	/**
	 * Get the SessionData object from an HTTP session.
	 *
	 * @param request
	 * @param touchSession
	 */
	private SessionData getSessionDataFromSession(HttpServletRequest request, boolean touchSession) {
		HttpSession session = request.getSession();

		SessionData sessionData = (SessionData) session.getAttribute("sessionData");

		if(sessionData != null && touchSession && !sessionData.getTransactionSessionData().isEmpty()) {
			sessionData.setLastSessionTouch(new Date());
		}

		return sessionData;
	}

	/**
	 * Set the sessionData param of the session to a new SessionData object.
	 *
	 * @param request
	 */
	private void setSessionDataToNewSession(HttpServletRequest request) {
		request.getSession().setAttribute("sessionData", new SessionData());
	}

	/**
	 * Add a new transaction id to the session object. (should only be called from quote start pages)
	 *
	 * @param request
	 * @return newSession
	 */
	public Data addNewTransactionDataToSession(HttpServletRequest request) throws DaoException {
		Data newSession = null;

		SessionData sessionData = getSessionDataFromSession(request);

		if(sessionData == null){
			setSessionDataToNewSession(request);
			sessionData = getSessionDataFromSession(request);
		}
		if(sessionData != null){
			sessionData.setShouldEndSession(false);
			String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
			String brandCode =  ApplicationService.getBrandCodeFromRequest(request);

			cleanUpSessions(sessionData);
			newSession = sessionData.addTransactionDataInstance();
		if (verticalCode == null || verticalCode.isEmpty()) {
			// this is to assist recovery if session is lost.
			verticalCode = VerticalType.GENERIC.getCode();
			LOGGER.warn("No vertical code provided; using generic instead");
		}

			newSession.put("current/verticalCode", verticalCode);
			newSession.put("current/brandCode", brandCode);
		}

		return newSession;
	}

	/**
	 * Get the Data object for the specified transaction id (searching either current or previous transaction id)
	 *
	 * @param request
	 * @param transactionId
	 * @param searchPreviousIds
	 * @throws SessionException
	 */
	public Data getDataForTransactionId(HttpServletRequest request, String transactionId, boolean searchPreviousIds) throws DaoException, SessionException {

		SessionData sessionData = getSessionDataForTransactionId(request, transactionId);

		Data data = sessionData.getSessionDataForTransactionId(transactionId);
		if (data == null) {
			// Check for previous id as the transaction might have been incremented (should only be true when called from get_transaction_id.jsp)
			data = sessionData.getSessionDataForPreviousTransactionId(Long.parseLong(transactionId));
		}

		if (data == null && searchPreviousIds) {
			// Check for previous id as the transaction might have been incremented (should only be true when called from get_transaction_id.jsp)
			data = sessionData.getSessionDataForPreviousTransactionId(Long.parseLong(transactionId));
		}

		return getProcessedDataForTransactionId(request, transactionId, data);
	}

	/**
	 * Get the Data object for the most recent transaction directly related to the
	 * specified transaction id
	 *
	 * @param request
	 * @param transactionId
	 * @throws SessionException
	 */
	public Data getDataForMostRecentRelatedTransactionId(HttpServletRequest request, String transactionId) throws DaoException, SessionException {

		SessionData sessionData = getSessionDataForTransactionId(request, transactionId);

		Data data = sessionData.getSessionDataForMostRecentRelatedTransactionId(Long.parseLong(transactionId));

		return getProcessedDataForTransactionId(request, transactionId, data);
	}

	/**
	 * Helper for getData methods above - provides codes common to both
	 *
	 * @param request
	 * @param transactionId
	 * @return
	 * @throws SessionException
	 */
	private SessionData getSessionDataForTransactionId(HttpServletRequest request, String transactionId) throws SessionException {
		SessionData sessionData = getSessionDataFromSession(request);
		if (sessionData == null ) {
			throw new SessionException("session has expired");
		}
		if (transactionId == null || transactionId.equals("")) {
			throw new SessionException("Transaction Id not provided");
		}
		return sessionData;
	}

	/**
	 * Helper for getData methods above - provides codes common to both
	 *
	 * @param request
	 * @param transactionId
	 * @param data
	 * @return
	 * @throws DaoException
	 * @throws SessionException
	 */
	private Data getProcessedDataForTransactionId(HttpServletRequest request, String transactionId, Data data) throws DaoException, SessionException {
		if (data == null) {
			LOGGER.warn("Unable to find matching data object in session. {}", kv("transactionId", transactionId));

			// Data object not found, create a new version (this is to assist with recovery).
			data = addNewTransactionDataToSession(request);
		}

		data.setLastSessionTouch(new Date());

		// If localhost or NXI, the URL writing is not in place, therefore we have fall back logic...
		if (!EnvironmentService.needsManuallyAddedBrandCodeParam()) {
			// Extra safety check, verify the brand code on the transaction object with the current brand code for this session.
			String dataBucketBrand = (String) data.get("current/brandCode");
			String applicationBrand = ApplicationService.getBrandCodeFromRequest(request);

			if (dataBucketBrand != null && !dataBucketBrand.equals("") && applicationBrand != null && !dataBucketBrand.equalsIgnoreCase(applicationBrand)) {
				LOGGER.error("Transaction doesn't match brand {},{}", kv("dataBucketBrand", dataBucketBrand), kv("applicationBrand", applicationBrand));
				throw new BrandException("Transaction doesn't match brand");
			}
		}

		// Set the vertical code on the request scope so settings can be loaded correctly.
		String dataBucketVerticalCode = (String) data.get("current/verticalCode");
		ApplicationService.setVerticalCodeOnRequest(request, dataBucketVerticalCode);

		return data;
	}
	/**
	 * Remove the specified transaction from the session. (usually called when restarting a quote)
	 * used by delete.tag
	 *
	 * @param request
	 * @param transactionId
	 */
	public void removeSessionForTransactionId(HttpServletRequest request, String transactionId) {
		SessionData sessionData = getSessionDataFromSession(request);
		Data data = sessionData.getSessionDataForTransactionId(transactionId);
		if(data != null) sessionData.getTransactionSessionData().remove(data);
	}

	/**
	 * Look for any sessions with no transaction Id and delete them.
	 *
	 * @param sessionData
	 */
	public void cleanUpSessions(SessionData sessionData) {
		ArrayList<Data> transactionSessions = sessionData.getTransactionSessionData();

		Collections.sort(transactionSessions);

		ArrayList<Data> itemsToDelete = new ArrayList<>();

		// Remove items with blank transaction id.
		for (Data session : transactionSessions) {

			String sessionTransactionId = (String) session.get("current/transactionId");
			if(sessionTransactionId == null || sessionTransactionId.equals("")){
				itemsToDelete.add(session);
			}

		}

		transactionSessions.removeAll(itemsToDelete);

		// Remove old sessions (will make 10 sessions the max number... could be anything, just worried about the size of the session object and server)
		int MAX_DATA_OBJECTS_IN_SESSION = 10;
		if(transactionSessions.size() >= MAX_DATA_OBJECTS_IN_SESSION){
			// Trim the oldest data objects.
			itemsToDelete = new ArrayList<>();
			itemsToDelete.addAll(transactionSessions.subList(0, transactionSessions.size()- MAX_DATA_OBJECTS_IN_SESSION));
			transactionSessions.removeAll(itemsToDelete);
		}
	}

	/**
	 * Return the last session touch as an epoch timestamp
	 * @param request
	 * @return Date
	 */
	private long getLastSessionTouchTimestamp(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session == null || session.isNew()) return -1;

		try {
			return getLastSessionTouch(request).getTime();
		} catch (NullPointerException e) {
			return -1;
		}
	}

	/**
	 * Return the last session touch as a date
	 * used in data.jsp
	 * @param request
	 * @return
	 */
	public Date getLastSessionTouch(HttpServletRequest request) throws NullPointerException {
		SessionData sessionData = getSessionDataFromSession(request, false);
		return sessionData.getLastSessionTouch();
	}

	/**
	 * Touch the session
	 * @param request
	 */
	public void touchSession(HttpServletRequest request){
		getSessionDataFromSession(request);
	}

	/**
	 * Get the client's next expected timeout (for JS timeout)
	 * @param request
	 */
	public long getClientSessionTimeout(HttpServletRequest request) {
		SessionData sessionData = getSessionDataFromSession(request, false);

		long now = new Date().getTime();
		long lastTouch = getLastSessionTouchTimestamp(request);

		if(lastTouch == -1 || sessionData.isShouldEndSession()) return -1;

		long expiryTime = getClientDefaultExpiryTimeout(request);
		return lastTouch + expiryTime - now;
	}

	/**
	 * Get the client's next expected timeout (for JS timeout)
	 * @param request
	 */
	public Long getClientSessionTimeoutSeconds(HttpServletRequest request) {
		long timeout = getClientSessionTimeout(request);
		if(timeout == -1){
			return getClientDefaultExpiryTimeoutSeconds(request);
		} else {
			return timeout /1000;
		}
	}


	/**
	 * Get a cookie's value by name
	 * used by write_quote.jsp
	 * @param request
	 * @param cookieName
	 * @return cookie value
	 */
	public String getCookieByName(HttpServletRequest request, String cookieName) {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals(cookieName)) {
					return cookie.getValue();
				}
			}
		}

		return "";
	}

	/**
	 * Get the default session timeout period (for JS timeout)
	 * used in session_pop.tag
	 * page.tag
	 * @param request
	 */
	public long getClientDefaultExpiryTimeout(HttpServletRequest request) {
		return ((request.getSession(false).getMaxInactiveInterval() / 60) - SESSION_EXPIRY_DIFFERENCE) * 60 * 1000;
	}

	/**
	 * Get the default session timeout period (for JS timeout)
	 * used in session_pop.tag
	 * page.tag
	 * @param request
	 */
	public long getClientDefaultExpiryTimeoutSeconds(HttpServletRequest request) {
		return getClientDefaultExpiryTimeout(request) / 1000;
	}

	public void setShouldEndSession(HttpServletRequest request, boolean shouldEnd) {
		SessionData sessionData = getSessionDataFromSession(request, false);
		sessionData.setShouldEndSession(shouldEnd);
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