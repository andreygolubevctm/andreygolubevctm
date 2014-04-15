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

import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.data.SessionData;
import com.ctm.data.dao.Vertical;
import com.ctm.data.exceptions.BrandException;
import com.ctm.data.exceptions.SessionException;
import com.ctm.services.EnvironmentService.Environment;
import com.disc_au.web.go.Data;


public class SessionDataService {

	private static Logger logger = Logger.getLogger(SessionDataService.class.getName());

	private static int MAX_DATA_OBJECTS_IN_SESSION = 10;


	// Return the authenticated session from the session object.
	public static Data getAuthenticatedSessionData(PageContext pageContext){
		SessionData sessionData = getSessionDataFromPageContent(pageContext);
		return sessionData.getAuthenticatedSessionData();
	}

	private static SessionData getSessionDataFromPageContent(PageContext pageContext){
		return (SessionData) pageContext.getAttribute("sessionData", PageContext.SESSION_SCOPE);
	}

	/**
	 * Add a new transaction id to the session object. (should only be called from quote start pages)
	 * @param pageContext
	 * @return
	 * @throws Exception
	 */
	public static Data addNewTransactionDataToSession(PageContext pageContext) throws Exception{

		cleanUpSessions(pageContext);

		SessionData sessionData = getSessionDataFromPageContent(pageContext);
		Data newSession = sessionData.addTransactionDataInstance();

		String currentVerticalCode = ApplicationService.getVerticalCodeFromPageContext(pageContext);
		if(currentVerticalCode == null){
			// this is to assist recovery if session is lost.
			currentVerticalCode = Vertical.GENERIC_CODE;
			logger.warn("Unable to get vertical code from page context - using generic instead");
		}

		newSession.put("current/verticalCode", currentVerticalCode);

		String brandCode =  ApplicationService.getBrandCodeFromPageContext(pageContext);

		if(brandCode == null && EnvironmentService.getEnvironment() == Environment.LOCALHOST){
			logger.error("BRAND CODE NOT SET IN LOCALHOST - DEFAULTING TO CTM");
			brandCode = "CTM";
			pageContext.setAttribute("brandCode",brandCode, PageContext.REQUEST_SCOPE);
		}

		newSession.put("current/brandCode", brandCode);

		return newSession;
	}

	/**
	 * Get the Data object for the specified transaction id (searching either current or previous transaction id)
	 * @param pageContext
	 * @param transactionId
	 * @param searchPreviousIds
	 * @return
	 * @throws Exception
	 */
	public static Data getSessionForTransactionId(PageContext pageContext, String transactionId, boolean searchPreviousIds) throws Exception{

		SessionData sessionData = getSessionDataFromPageContent(pageContext);

		if(transactionId.equals("") || transactionId == null){
			throw new SessionException("Transaction Id not provided");
		}else{

			Data data = sessionData.getSessionDataForTransactionId(transactionId);

			if(data == null && searchPreviousIds == true){
				// Check for previous id as the transaction might have been incremented (should only be true when called from get_transaction_id.jsp)
				data = sessionData.getSessionDataForPreviousTransactionId(transactionId);
			}

			if(data == null){
				// Data object not found, create a new version (this is to assist with recovery).
				logger.warn("Unable to find matching data object in session for "+transactionId);
				data = addNewTransactionDataToSession(pageContext);
			}

			data.setLastSessionTouch(new Date());

			// Extra safety check, verify the brand code on the transaction object with the current brand code for this session.
			String dataBucketBrand = (String) data.get("current/brandCode");
			String applicationBrand = ApplicationService.getBrandCodeFromPageContext(pageContext);

			if(dataBucketBrand != null && dataBucketBrand.equals("") == false && applicationBrand != null && dataBucketBrand.equalsIgnoreCase(applicationBrand) == false){
				logger.error("Transaction doesn't match brand: "+dataBucketBrand+"!="+ApplicationService.getBrandCodeFromPageContext(pageContext));
				throw new BrandException("Transaction doesn't match brand");
			}

			// Set the vertical code on the request scope so settings can be loaded correctly.
			String dataBucketVerticalCode = (String) data.get("current/verticalCode");
			ApplicationService.setVerticalCodeOnPageContext(pageContext, dataBucketVerticalCode);

			return data;
		}
	}

	/**
	 * Remove the specified transaction from the session. (usually called when restarting a quote)
	 * @param pageContext
	 * @param transactionId
	 */
	public static void removeSessionForTransactionId(PageContext pageContext, String transactionId){
		SessionData sessionData = getSessionDataFromPageContent(pageContext);
		Data data = sessionData.getSessionDataForTransactionId(transactionId);
		if(data != null) sessionData.getTransactionSessionData().remove(data);
	}

	/**
	 * Look for any sessions with no transaction Id and delete them.
	 * @param pageContext
	 */
	public static void cleanUpSessions(PageContext pageContext){

		SessionData sessionData = getSessionDataFromPageContent(pageContext);

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

}
