package com.ctm.services;

import com.ctm.dao.TouchDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.AccessTouch.AccessCheck;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;

public class AccessTouchService {

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
}
