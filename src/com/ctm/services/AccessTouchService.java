package com.ctm.services;

import com.ctm.dao.TouchDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.AccessTouch.AccessCheck;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.router.IncomingEmailRouter;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

public class AccessTouchService {

	private static Logger logger = Logger.getLogger(IncomingEmailRouter.class.getName());

	protected final SessionDataService sessionDataService;

	TouchDao dao = new TouchDao();
	private HttpServletRequest request;

	public AccessTouchService(TouchDao dao ,SessionDataService sessionDataService) {
		this.dao = dao;
		this.sessionDataService = sessionDataService;
	}

	public AccessTouchService() {
		dao = new TouchDao();
		this.sessionDataService = new SessionDataService();
	}

	public AccessTouch getLatestAccessTouchByTransactionId(long transactionId , String operatorId) throws DaoException{
		AccessCheck accessCheck = AccessCheck.LOCKED;
		AccessTouch touch = dao.getlatestAccessTouch(transactionId);
		if(touch == null) {
			accessCheck = AccessCheck.NO_TOUCHES;
			touch = new AccessTouch();
		} else {
			if (touch.getExpired() == 1){
				accessCheck = AccessCheck.EXPIRED;
			} else if (touch.getType() == TouchType.UNLOCKED){
				accessCheck = AccessCheck.UNLOCKED;
			} else if (touch.getType() == TouchType.SUBMITTED) {
				accessCheck = AccessCheck.SUMMITTED;
			} else if (touch.getOperator().equals(Touch.ONLINE_USER)){
				accessCheck = AccessCheck.ONLINE;
			} else if (touch.getOperator().equals(operatorId)){
				accessCheck = AccessCheck.MATCHING_OPERATOR;
			}
		}
		touch.setAccessCheck(accessCheck);

		return touch;
	}

	// Don't reorder any of the recordTouch methods.
	// Doing so will cause hell to break loose.
	// JSP tries to 'best match' calls to overloaded methods
	// and does so on a first-come first-served basis. This results
	// in the method with HttpServletRequest as the first parameter to
	// complain.
	public Boolean recordTouch(long transactionId, String type) {
		return recordTouch(transactionId,  type , null);
	}

	public Boolean recordTouch(Long transactionId, String type , String operatorId, String description) {
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				operatorId = authenticatedData.getUid();
			}
		}
		try {
			Touch touch = new Touch();
			touch.setTransactionId(transactionId);
			touch.setType(TouchType.findByCode(type));
			touch.setOperator(operatorId);
			touch.setDescription(description);
			dao.record(touch);
			return true;
		} catch(DaoException e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			String message = "Failed to record touch (" + type + ") against transaction [" + transactionId + "].";
			logger.error(message, e);
			return false;
		}
	}

	public Boolean recordTouch(long transactionId, String type , String operatorId) {
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				operatorId = authenticatedData.getUid();
			}
		}

		try {
			dao.record(transactionId, type, operatorId);
			return true;
		} catch(DaoException e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			logger.error("Failed to record touch (" + type + ") against transaction [" + transactionId + "].");
			logger.error(e);
			return false;
		}
	}

	public Boolean recordTouchWithDescription(long transactionId, String type, String description) {
		// Set operator to null - the TouchDao will use this as 'ONLINE' if not superseded
		String operator = null;
		// Populate operator from authenticated data if available
		if (request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				operator = authenticatedData.getUid();
			}
		}

		return recordTouch(transactionId,  type , operator, description);

	}

	public boolean hasTouch(final long transactionId, final TouchType touchType) throws DaoException {
		return dao.hasTouch(transactionId, touchType.getCode());
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
}
