package com.ctm.services;

import com.ctm.dao.TouchDao;

import com.ctm.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.TouchCommentProperty;
import com.ctm.model.TouchProductProperty;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.router.IncomingEmailRouter;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.logging.LoggingArguments.kv;

public class AccessTouchService {

	private static final Logger LOGGER = LoggerFactory.getLogger(IncomingEmailRouter.class);

	protected final SessionDataService sessionDataService;

	TouchDao dao;
	private HttpServletRequest request;

	public AccessTouchService(TouchDao dao ,SessionDataService sessionDataService) {
		this.dao = dao;
		this.sessionDataService = sessionDataService;
	}

	public AccessTouchService() {
		dao = new TouchDao();
		this.sessionDataService = new SessionDataService();
	}

	// Don't reorder any of the recordTouch(*) methods.
	// Doing so will cause hell to break loose.
	// JSP tries to 'best match' calls to overloaded methods
	// and does so on a first-come first-served basis. This results
	// in the method with HttpServletRequest as the first parameter to
	// complain.
	public Boolean recordTouch(long transactionId, String type) {
		return recordTouch(transactionId,  type , null);
	}

	public Boolean recordTouch(long transactionId, String type , String operatorId) {
		Touch touch = createTouchObject(transactionId, type, operatorId);
		return recordTouch(touch);
	}

	public Boolean recordTouch(Touch touch){
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				touch.setOperator(authenticatedData.getUid());
			}
		}

		try {
			dao.record(touch);
			return true;
		} catch(DaoException e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			LOGGER.error("Failed to record touch {}", kv("touch", touch), e);
			return false;
		}
	}

	public Boolean recordTouchWithProductCode(long transactionId, String type, String productCode) {
		return recordTouchWithProductCode(transactionId, type, null, productCode);
	}

	public Boolean recordTouchWithProductCode(long transactionId, String type, String operatorId, String productCode) {
		Touch touch = createTouchObject(transactionId, type, operatorId);

		if (StringUtils.isNotBlank(productCode)) {
			TouchProductProperty touchProductProperty = new TouchProductProperty();
			touchProductProperty.setProductCode(productCode);
			touch.setTouchProductProperty(touchProductProperty);
		}

		return recordTouch(touch);
	}

	public Boolean recordTouchWithComment(long transactionId, String type, String comment) {
		return recordTouchWithComment(transactionId, type, null, comment);
	}

	public Boolean recordTouchWithComment(long transactionId, String type, String operatorId, String comment) {
		Touch touch = createTouchObject(transactionId, type, operatorId);

		if (StringUtils.isNotBlank(comment)) {
			TouchCommentProperty touchCommentProperty = new TouchCommentProperty();
			touchCommentProperty.setComment(comment);
			touch.setTouchCommentProperty(touchCommentProperty);
		}

		return recordTouch(touch);
	}

	public static Touch createTouchObject(Long transactionId, String type) {
		return createTouchObject(transactionId, type, null);
	}

	public static Touch createTouchObject(Long transactionId, String type, String operatorId) {
		Touch touch = new Touch();
		touch.setTransactionId(transactionId);
		touch.setType(TouchType.findByCode(type));

		if(StringUtils.isNotEmpty(operatorId))
			touch.setOperator(operatorId);

		return touch;
	}

	public boolean hasTouch(final long transactionId, final TouchType touchType) throws DaoException {
		return dao.hasTouch(transactionId, touchType.getCode());
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
}

    public boolean isBeingSubmitted(Long transactionId) {
        boolean isBeingSubmitted = false;
        try {
            Touch touch = dao.getLatestTouchByTransactionId(transactionId);
            if(touch != null ){
                isBeingSubmitted = touch.getType() == Touch.TouchType.SUBMITTED;
            }
        } catch (DaoException e) {
            LOGGER.error("Failed to determine latest touch {}", kv("transactionId", transactionId), e);
        }
        return isBeingSubmitted;
    }
}
