package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.Touch.TouchType;
import org.junit.Test;

import java.util.Date;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class AccessTouchServiceTest {

	private TouchDao touchDao = mock(TouchDao.class);
	private long transactionId = 1234567;
    private SessionDataService sessionDataService= mock(SessionDataService.class);

    @Test
    public void shouldGetIsBeingSubmitted() throws DaoException {
        AccessTouchService service = new AccessTouchService(touchDao ,  sessionDataService);
        assertFalse(service.isBeingSubmitted(transactionId));

        // quote is not pending
        Touch accessTouch = getNewAccessTouch();
        accessTouch.setType(TouchType.RESULTS_SINGLE);
        assertFalse(service.isBeingSubmitted(transactionId));


        // quote is pending
        accessTouch = getNewAccessTouch();
        accessTouch.setType(TouchType.SUBMITTED);

        assertTrue(service.isBeingSubmitted(transactionId));
    }

    private Touch getNewAccessTouch() throws DaoException {
        Touch accessTouch = new Touch();
        accessTouch.setDatetime(new Date());
        accessTouch.setType(TouchType.PRICE_PRESENTATION);
        accessTouch.setOperator("test2");
        when(touchDao.getLatestTouchByTransactionId(transactionId)).thenReturn(accessTouch );
        return accessTouch;
    }

}
