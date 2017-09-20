package com.ctm.web.core.model.session;

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

import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.utils.SessionDataUtils;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Date;

import static com.ctm.web.core.utils.SessionDataUtils.getTransactionId;

public class SessionData {

    private static final Logger LOGGER = LoggerFactory.getLogger(SessionData.class);

	final private ArrayList<Data> transactionSessionData;
	private AuthenticatedData authenticatedSessionData;

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
	 * @param data
	 * @return
	 */
	public Data addTransactionData(Data data){
		getTransactionSessionData().add(data);
		return data;
	}

	/**
	 *
	 * @param transactionId that is stored against the data
	 * @return Data
	 */
	public Data getSessionDataForTransactionId(long transactionId){

		ArrayList<Data> sessions = getTransactionSessionData();

		for (Data session : sessions) {
			Long sessionTransactionId = getTransactionId(session);
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
			String sessionTransactionId = (String) session.get(SessionDataUtils.CURRENT_TRANSACTION_ID_XPATH);
			if(sessionTransactionId != null && sessionTransactionId.equals(transactionId)){
				return session;
			} else if("0".equals(transactionId) && sessionTransactionId == null){
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

	/**
	 *
	 * @param transactionId previously known transaction id
	 * @return Data null if cannot be found
	 */
	public Data getSessionDataForMostRecentRelatedTransactionId(long transactionId){

		long latestTransactionId = 0;
		TransactionDao tranDao = new TransactionDao();
		try {
			latestTransactionId = tranDao.getMostRecentRelatedTransactionId(transactionId);
		} catch (DaoException e) {
            LOGGER.error("failed to check db" , e);
        }

		if(latestTransactionId > 0) {
			ArrayList<Data> sessions = getTransactionSessionData();
			long sessionTransactionId = 0;

			for (Data session : sessions) {
				try {
					sessionTransactionId = session.getLong("current/transactionId");
				} catch (Exception e) {

				}
				if (sessionTransactionId > 0 && sessionTransactionId == latestTransactionId) {
					return session;
				}
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

	public void resetAuthenticatedSessionData() {
		authenticatedSessionData = new AuthenticatedData();
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
