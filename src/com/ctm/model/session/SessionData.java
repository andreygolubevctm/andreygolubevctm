package com.ctm.model.session;

/**
 *
 * Session data.
 *
 * This object sits in the user's session and holds an array of Data objects for each transaction Id that they have
 * It also contains a separate Data object containing the user's authenticated session (if applicable).
 *
 * Note: This should be session scoped.
 *
 */

import java.util.ArrayList;

import com.disc_au.web.go.Data;

public class SessionData {

	final private ArrayList<Data> transactionSessionData;
	final private AuthenticatedData authenticatedSessionData;

	public SessionData(){
		transactionSessionData = new ArrayList<Data>();
		authenticatedSessionData = new AuthenticatedData();

	}

	/**
	 *
	 * @return
	 */
	public Data addTransactionDataInstance(){
		Data newSession = new Data();
		getTransactionSessionData().add(newSession);
		return newSession;
	}

	/**
	 *
	 * @param transactionId
	 * @return
	 */
	public Data getSessionDataForTransactionId(String transactionId){

		ArrayList<Data> sessions = getTransactionSessionData();

		for (Data session : sessions) {
			String sessionTransactionId = (String) session.get("current/transactionId");
			if(sessionTransactionId != null && sessionTransactionId.equals(transactionId)){
				return session;
			}
		}

		return null;
	}

	/**
	 *
	 * @param previousTransactionId
	 * @return
	 */
	public Data getSessionDataForPreviousTransactionId(String previousTransactionId){

		ArrayList<Data> sessions = getTransactionSessionData();

		for (Data session : sessions) {
			String sessionTransactionId = (String) session.get("current/previousTransactionId");
			if(sessionTransactionId != null && sessionTransactionId.equals(previousTransactionId)){
				return session;
			}
		}

		return null;

	}


	public ArrayList<Data> getTransactionSessionData() {
		return transactionSessionData;
	}

	public AuthenticatedData getAuthenticatedSessionData() {
		return authenticatedSessionData;
	}

}
