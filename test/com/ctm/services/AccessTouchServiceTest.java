package com.ctm.services;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.Date;

import org.junit.Test;

import com.ctm.dao.TouchDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.AccessTouch.AccessCheck;
import com.ctm.model.Touch.TouchType;

public class AccessTouchServiceTest {

	private TouchDao touchDao = mock(TouchDao.class);
	private long transactionId = 1234567;

	@Test
	public void testShouldGetAccessCheck() throws SQLException, DaoException {
		String operatorId = "test";
		AccessTouch accessTouch = getNewAccessTouch();

		AccessTouchService service = new AccessTouchService(touchDao);

		// 0 quote is locked
		AccessTouch returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);
		assertEquals(AccessCheck.LOCKED , returnedTouch.getAccessCheck() );

		// lock has expired
		accessTouch.setExpired(1);
		returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);

		assertEquals( AccessCheck.EXPIRED , returnedTouch.getAccessCheck() );

		// has been unlocked by the call centre
		accessTouch = getNewAccessTouch();
		accessTouch.setType(TouchType.UNLOCKED);

		returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);
		assertEquals(AccessCheck.UNLOCKED, returnedTouch.getAccessCheck() );

		// quote is pending
		accessTouch = getNewAccessTouch();
		accessTouch.setType(TouchType.SUBMITTED);

		returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);
		assertEquals(AccessCheck.SUMMITTED, returnedTouch.getAccessCheck() );

		// quote is online so no lock
		accessTouch = getNewAccessTouch();
		accessTouch.setOperator(AccessTouch.ONLINE);

		returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);
		assertEquals(AccessCheck.ONLINE, returnedTouch.getAccessCheck() );

		// matching operator so no lock
		accessTouch = getNewAccessTouch();
		accessTouch.setOperator(operatorId);

		returnedTouch = service.getLatestAccessTouchByTransactionId(transactionId, operatorId);
		assertEquals(AccessCheck.MATCHING_OPERATOR, returnedTouch.getAccessCheck() );
	}

	private AccessTouch getNewAccessTouch() throws DaoException {
		AccessTouch accessTouch = new AccessTouch();
		accessTouch.setDatetime(new Date());
		accessTouch.setType(TouchType.PRICE_PRESENTATION);
		accessTouch.setOperator("test2");
		accessTouch.setExpired(0);
		when(touchDao.getlatestAccessTouch(transactionId)).thenReturn(accessTouch );
		return accessTouch;
	}

}
