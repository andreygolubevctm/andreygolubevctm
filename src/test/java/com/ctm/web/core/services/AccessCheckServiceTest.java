package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.dao.transaction.TransactionLockDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.transaction.TransactionLock;
import org.junit.Test;

import java.sql.SQLException;
import java.util.Date;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class AccessCheckServiceTest {

	private TouchDao touchDao = mock(TouchDao.class);
	private TransactionLockDao transactionLockDao = mock(TransactionLockDao.class);
	private long transactionId = 1234567;
	private String operatorId = "test";

	@Test
	public void testShouldGetAccessCheck() throws SQLException, DaoException {
		AccessCheckService service = new AccessCheckService(touchDao, transactionLockDao);

		// 0 quote is locked
		TransactionLock locked = new TransactionLock();
		locked.operatorId = "mctest";
		locked.lockDateTime = new Date();
		when(transactionLockDao.getLatest(transactionId)).thenReturn(locked);
		boolean returnedTouch = service.getIsLockedByTransactionId(transactionId, operatorId);

		assertTrue(returnedTouch);

		when(transactionLockDao.getLatest(transactionId)).thenReturn(null);
		Touch accessTouch;

		// quote is online so no lock
		accessTouch = getNewAccessTouch();
		accessTouch.setOperator("ONLINE");

		returnedTouch = service.getIsLockedByTransactionId(transactionId, operatorId);
		assertFalse(returnedTouch);

		// matching operator so no lock
		accessTouch = getNewAccessTouch();
		accessTouch.setOperator(operatorId);

		TransactionLock matching = new TransactionLock();
		matching.operatorId = operatorId;
		matching.lockDateTime = new Date();
		when(transactionLockDao.getLatest(transactionId)).thenReturn(matching);
		returnedTouch = service.getIsLockedByTransactionId(transactionId, operatorId);
		assertFalse(returnedTouch);
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
