package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.TouchDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.AccessTouch.AccessCheck;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.router.IncomingEmailRouter;

public class AccessTouchService {

	private static Logger logger = Logger.getLogger(IncomingEmailRouter.class.getName());

	TouchDao dao = new TouchDao();

	public AccessTouchService(TouchDao dao ) {
		this.dao = dao;
	}

	public AccessTouchService() {
		dao = new TouchDao();
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
			} else if (touch.getOperator().equals(Touch.ONLINE)){
				accessCheck = AccessCheck.ONLINE;
			} else if (touch.getOperator().equals(operatorId)){
				accessCheck = AccessCheck.MATCHING_OPERATOR;
			}
		}
		touch.setAccessCheck(accessCheck);

		return touch;
	}

	public Boolean recordTouch(long transactionId, String type) {

		try {
			dao.record(transactionId, type);
			return true;
		} catch(DaoException e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			logger.error("Failed to record touch (" + type + ") against transaction [" + transactionId + "].");
			logger.error(e);
			return false;
		}
	}
}
