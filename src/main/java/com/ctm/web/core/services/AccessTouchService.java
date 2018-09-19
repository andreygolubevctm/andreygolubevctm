package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchDao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.TouchCommentProperty;
import com.ctm.web.core.model.TouchProductProperty;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.router.IncomingEmailRouter;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class AccessTouchService {

	private static final Logger LOGGER = LoggerFactory.getLogger(IncomingEmailRouter.class);

	private SessionDataServiceBean sessionDataServiceBean;

	protected SessionDataService sessionDataService;

    private TouchDao dao;
	private HttpServletRequest request;

	@Autowired
	public AccessTouchService(TouchDao dao, SessionDataServiceBean sessionDataServiceBean) {
		this.dao = dao;
		this.sessionDataServiceBean = sessionDataServiceBean;
	}

    @Deprecated
	public AccessTouchService(TouchDao dao ,SessionDataService sessionDataService) {
		this.dao = dao;
		this.sessionDataService = sessionDataService;
	}

    @Deprecated
	public AccessTouchService() {
		dao = new TouchDao();
		this.sessionDataService = new SessionDataService();
	}

	// Don't reorder any of the recordTouchDeprecated(*) methods.
	// Doing so will cause hell to break loose.
	// JSP tries to 'best match' calls to overloaded methods
	// and does so on a first-come first-served basis. This results
	// in the method with HttpServletRequest as the first parameter to
	// complain.
	public Boolean recordTouchDeprecated(long transactionId, String type) {
		return recordTouchDeprecated(transactionId,  type , null);
	}

	public Boolean recordTouchDeprecated(long transactionId, String type , String operatorId) {
		Touch touch = createTouchObject(transactionId, type, operatorId);
		return recordTouchDeprecated(touch);
	}

	public Boolean recordTouch(long transactionId, String type , String operatorId) {
		Touch touch = createTouchObject(transactionId, type, operatorId);
		return recordTouch(touch);
	}

	public Boolean recordTouchDeprecated(Touch touch){
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				touch.setOperator(authenticatedData.getUid());
			}
		}

		return record(touch);
	}

	private Boolean record(Touch touch) {
		try {
			dao.record(touch);
			return true;
		} catch(DaoException e) {
			// Failing to write the touch shouldn't be fatal - let's just log an error
			LOGGER.error("Failed to record touch {}", kv("touch", touch), e);
			return false;
		}
	}

	public Boolean recordTouch(Touch touch){
		if (request != null && request.getSession() != null) {
			AuthenticatedData authenticatedData = sessionDataServiceBean.getAuthenticatedSessionData(request);
			if(authenticatedData != null) {
				touch.setOperator(authenticatedData.getUid());
			}
		}
		return record(touch);
	}

	public Boolean recordTouchWithProductCodeDeprecated(long transactionId, String type, String productCode) {
		return recordTouchWithProductCodeDeprecated(transactionId, type, null, productCode);
	}

	public Boolean recordTouchWithProductCodeDeprecated(long transactionId, String type, String operatorId, String productCode) {
		Touch touch = createTouchObject(transactionId, type, operatorId);

		if (StringUtils.isNotBlank(productCode)) {
			TouchProductProperty touchProductProperty = new TouchProductProperty();
			touchProductProperty.setProductCode(productCode);
			touch.setTouchProductProperty(touchProductProperty);
		}

		return recordTouchDeprecated(touch);
	}

	public Boolean recordTouchWithProductCode(long transactionId, String type, String operatorId, String productCode) {
		Touch touch = createTouchObject(transactionId, type, operatorId);

		if (StringUtils.isNotBlank(productCode)) {
			TouchProductProperty touchProductProperty = new TouchProductProperty();
			touchProductProperty.setProductCode(productCode);
			touch.setTouchProductProperty(touchProductProperty);
		}

		return recordTouchDeprecated(touch);
	}

	public void updateTouch(long transactionId, Touch.TouchType type) {
		TouchDao touchDao = new TouchDao();
		try {
			touchDao.updateTouch(transactionId, type);
		} catch(DaoException e){

		}

	}

	public Boolean recordTouchWithCommentJSP(long transactionId, String type, String comment) {
		return recordTouchWithComment(transactionId, type, null, comment);
	}

	public Boolean recordTouchWithComment(long transactionId, Touch.TouchType type, String comment) {
		return recordTouchWithComment(transactionId, type.getCode(), null, comment);
	}


	public Boolean recordTouchWithComment(long transactionId, String type, String operatorId, String comment) {
		Touch touch = createTouchObject(transactionId, type, operatorId);

		if (StringUtils.isNotBlank(comment)) {
			TouchCommentProperty touchCommentProperty = new TouchCommentProperty();
			touchCommentProperty.setComment(comment);
			touch.setTouchCommentProperty(touchCommentProperty);
		}

		return recordTouchDeprecated(touch);
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

	public boolean touchCheck(final long transactionId, String type) throws DaoException {
		return dao.hasTouch(transactionId, type);
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
