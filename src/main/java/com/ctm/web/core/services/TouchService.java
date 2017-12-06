package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.TouchProductProperty;
import com.ctm.web.core.model.TouchLifebrokerProperty;
import com.ctm.web.core.model.session.AuthenticatedData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * This is use just by in JAVA and AccessTouchService.java is too dangerous to refactor.
 * Once the JSPs no longer use AccessTouchService it can be deleted.
 */
public class TouchService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TouchService.class);

    private static final TouchService INSTANCE = new TouchService();

    private final TouchDao touchDao = new TouchDao();

    private final SessionDataService sessionDataService = new SessionDataService();

    public static TouchService getInstance() {
        return INSTANCE;
    }

    public boolean recordTouchWithProductCode(final HttpServletRequest request, final Touch touch, String productCode){
        final TouchProductProperty touchProductProperty = new TouchProductProperty();
        touchProductProperty.setProductCode(productCode);
        touch.setTouchProductProperty(touchProductProperty);
        return recordTouch(request, touch);
    }

    public boolean recordTouchWithLifebrokerReference(final Touch touch, String clientReference){
        final TouchLifebrokerProperty touchLifebrokerProperty = new TouchLifebrokerProperty();
        touchLifebrokerProperty.setClientReference(clientReference);
        touch.setTouchLifebrokerProperty(touchLifebrokerProperty);
        return recordTouch(touch);
    }

    /**
     *
     * @param request
     * @param touch
     * @return
     */
    public boolean recordTouch(final HttpServletRequest request, final Touch touch){
        if (request != null && request.getSession() != null) {
            AuthenticatedData authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
            if(authenticatedData != null) {
                touch.setOperator(authenticatedData.getUid());
            }
        }
        try {
            touchDao.record(touch);
            return true;
        } catch(DaoException e) {
            // Failing to write the touch shouldn't be fatal - let's just log an error
            LOGGER.warn("Failed to record {} {}", kv("touch",touch.getType()), kv("transactionId", touch.getTransactionId()));
            return false;
        }
    }

    /**
     *
     * @param touch
     * @return
     */
    public boolean recordTouch(final Touch touch){
        try {
            touchDao.record(touch);
            return true;
        } catch(DaoException e) {
            // Failing to write the touch shouldn't be fatal - let's just log an error
            LOGGER.warn("Failed to record {} {}", kv("touch",touch.getType()), kv("transactionId", touch.getTransactionId()));
            return false;
        }
    }

}
