package com.ctm.services;

/**
*
* Session service.
*
* This class is the handler for when using the session object. It contains the application logic for verifying session information.
*
* Note: This is should be application scoped (all methods should therefore be static)
*
*/

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.ctm.exceptions.BrandException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.Vertical.VerticalType;
import com.disc_au.web.go.Data;


public class SessionDataService {

	private static Logger logger = Logger.getLogger(SessionDataService.class.getName());

	private static int MAX_DATA_OBJECTS_IN_SESSION = 10;

	private static final int SESSION_EXPIRY_DIFFERENCE = 5;

	/**
	 * Return the authenticated session from the session object.
	 *
	 * @param session
	 */
	public AuthenticatedData getAuthenticatedSessionData(HttpServletRequest request) {
		SessionData sessionData = getSessionDataFromSession(request);
		return sessionData.getAuthenticatedSessionData();
	}

	/**
	 * Get the SessionData object from an HTTP session.
	 *
	 * @param session
	 */
	public SessionData getSessionDataFromSession(HttpServletRequest request) {
		return getSessionDataFromSession(request, true);
	}

	/**
	 * Get the SessionData object from an HTTP session.
	 *
	 * @param session
	 * @param touchSession
	 */
	public SessionData getSessionDataFromSession(HttpServletRequest request, boolean touchSession) {
		HttpSession session = request.getSession();

		SessionData sessionData = (SessionData) session.getAttribute("sessionData");

		if(sessionData != null && touchSession && !sessionData.getTransactionSessionData().isEmpty()) {
			sessionData.setLastSessionTouch(new Date());
		}

		return sessionData;
	}

	/**
	 * Set the sessionData param of the session to a new sessiondata object.
	 *
	 * @param session
	 */
	public void setSessionDataToNewSession(HttpServletRequest request) {
		request.getSession().setAttribute("sessionData", new SessionData());
	}

	/**
	 * Add a new transaction id to the session object. (should only be called from quote start pages)
	 *
	 * @param session
	 * @param request
	 * @return newSession
	 */
	public Data addNewTransactionDataToSession(HttpServletRequest request) throws DaoException {

		SessionData sessionData = getSessionDataFromSession(request);

		if(sessionData == null){
			setSessionDataToNewSession(request);
			sessionData = getSessionDataFromSession(request);
		}

		sessionData.setShouldEndSession(false);

		String verticalCode = ApplicationService.getVerticalCodeFromRequest(request);
		String brandCode =  ApplicationService.getBrandCodeFromRequest(request);

		if(sessionData != null){
			cleanUpSessions(sessionData);
		}

		Data newSession = sessionData.addTransactionDataInstance();

		if (verticalCode == null || verticalCode.isEmpty()) {
			// this is to assist recovery if session is lost.
			verticalCode = VerticalType.GENERIC.getCode();
			logger.warn("addNewTransactionDataToSession: No vertical code provided; using generic instead");
		}

		newSession.put("current/verticalCode", verticalCode);
		newSession.put("current/brandCode", brandCode);

		return newSession;
	}

	/**
	 * Get the Data object for the specified transaction id (searching either current or previous transaction id)
	 *
	 * @param session
	 * @param transactionId
	 * @param searchPreviousIds
	 * @throws SessionException
	 */
	public Data getDataForTransactionId(HttpServletRequest request, String transactionId, boolean searchPreviousIds) throws DaoException, SessionException {

		SessionData sessionData = getSessionDataFromSession(request);
		if (sessionData == null ) {
			throw new SessionException("session has expired");
		}

		if (transactionId == null || transactionId.equals("")) {
			throw new SessionException("Transaction Id not provided");
		} else {

			Data data = sessionData.getSessionDataForTransactionId(transactionId);

			if (data == null && searchPreviousIds == true) {
				// Check for previous id as the transaction might have been incremented (should only be true when called from get_transaction_id.jsp)
				data = sessionData.getSessionDataForPreviousTransactionId(transactionId);
			}

			if (data == null) {
				logger.warn("Unable to find matching data object in session for "+transactionId);

				// Data object not found, create a new version (this is to assist with recovery).
				data = addNewTransactionDataToSession(request);
			}

			data.setLastSessionTouch(new Date());

			// If localhost or NXI, the URL writing is not in place, therefore we have fall back logic...
			if (EnvironmentService.needsManuallyAddedBrandCodeParam()) {
				logger.warn("Skipping transaction brand check for LOCALHOST, NXI and NXS");
			}
			else {
				// Extra safety check, verify the brand code on the transaction object with the current brand code for this session.
				String dataBucketBrand = (String) data.get("current/brandCode");
				String applicationBrand = null;

				applicationBrand = ApplicationService.getBrandCodeFromRequest(request);

				if (dataBucketBrand != null && dataBucketBrand.equals("") == false && applicationBrand != null && dataBucketBrand.equalsIgnoreCase(applicationBrand) == false) {
					logger.error("Transaction doesn't match brand: " + dataBucketBrand + "!=" + applicationBrand);
					throw new BrandException("Transaction doesn't match brand");
				}
			}

			// Set the vertical code on the request scope so settings can be loaded correctly.
			String dataBucketVerticalCode = (String) data.get("current/verticalCode");
			ApplicationService.setVerticalCodeOnRequest(request, dataBucketVerticalCode);

			return data;
		}
	}

	/**
	 * Remove the specified transaction from the session. (usually called when restarting a quote)
	 *
	 * @param session
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

		ArrayList<Data> itemsToDelete = new ArrayList<Data>();

		// Remove items with blank transaction id.
		for (Data session : transactionSessions) {

			String sessionTransactionId = (String) session.get("current/transactionId");
			if(sessionTransactionId == null || sessionTransactionId.equals("")){
				itemsToDelete.add(session);
			}

		}

		transactionSessions.removeAll(itemsToDelete);

		// Remove old sessions (will make 10 sessions the max number... could be anything, just worried about the size of the session object and server)
		if(transactionSessions.size() >= MAX_DATA_OBJECTS_IN_SESSION){
			// Trim the oldest data objects.
			itemsToDelete = new ArrayList<Data>();
			itemsToDelete.addAll(transactionSessions.subList(0, transactionSessions.size()-MAX_DATA_OBJECTS_IN_SESSION));
			transactionSessions.removeAll(itemsToDelete);
		}
	}

	/**
	 * Return the last session touch as an epoch timestamp
	 * @param request
	 * @param transactionId
	 * @return Date
	 */
	public long getLastSessionTouchTimestamp(HttpServletRequest request) {
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
	 * Get a cookie's value by name
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
	 * @param request
	 * @param shouldEnd
	 */
	public long getClientDefaultExpiryTimeout(HttpServletRequest request) {
		return ((request.getSession(false).getMaxInactiveInterval() / 60) - SESSION_EXPIRY_DIFFERENCE) * 60 * 1000;
	}

	public void setShouldEndSession(HttpServletRequest request, boolean shouldEnd) {
		SessionData sessionData = getSessionDataFromSession(request, false);
		sessionData.setShouldEndSession(shouldEnd);
	}

}
