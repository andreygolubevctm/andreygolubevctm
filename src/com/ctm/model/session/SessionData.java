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

import com.disc_au.web.go.Data;

import java.util.ArrayList;
import java.util.Date;

import static com.ctm.utils.SessionDataUtils.getTransactionIdFromTransactionSessionData;

public class SessionData {

	final private ArrayList<Data> transactionSessionData;
	final private AuthenticatedData authenticatedSessionData;

	private Date lastSessionTouch;
	private boolean shouldEndSession = false;

	public SessionData(){
		transactionSessionData = new ArrayList<>();
		authenticatedSessionData = new AuthenticatedData();
	}

	/**
	 *
	 * @return Data
	 */
	public Data addTransactionDataInstance(){
		Data newSession = new Data();
		getTransactionSessionData().add(newSession);
		return newSession;
	}

	/**
	 *
	 * @param transactionId that is stored against the data
	 * @return Data
	 */
	public Data getSessionDataForTransactionId(long transactionId){

		ArrayList<Data> sessions = getTransactionSessionData();

		for (Data session : sessions) {
			Long sessionTransactionId = getTransactionIdFromTransactionSessionData(session);
			if(sessionTransactionId != null && sessionTransactionId > 0 && sessionTransactionId == transactionId){
				return session;
			}
		}

		return null;
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
	 * @param previousTransactionId previously known transaction id
	 * @return Data null if cannot be found
	 */
	public Data getSessionDataForPreviousTransactionId(long previousTransactionId){

		ArrayList<Data> sessions = getTransactionSessionData();
		long sessionTransactionId = 0;

		for (Data session : sessions) {
			try {
				sessionTransactionId = session.getLong("current/previousTransactionId");
			} catch(Exception e) {

			}
			if(sessionTransactionId > 0 && sessionTransactionId == previousTransactionId){
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

	public Date getLastSessionTouch() {
		return lastSessionTouch;
	}

	public void setLastSessionTouch(Date lastTouch) {
		this.lastSessionTouch = lastTouch;
	}

	public boolean isShouldEndSession() {
		return shouldEndSession;
	}

	public void setShouldEndSession(boolean shouldEnd) {
		this.shouldEndSession = shouldEnd;
	}

}
