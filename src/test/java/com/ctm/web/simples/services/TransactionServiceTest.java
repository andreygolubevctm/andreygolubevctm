package com.ctm.web.simples.services;

import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.simples.model.Message;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class TransactionServiceTest {

	@Test
	public void testGetTransactionEmpty() throws Exception {
		final long tranId = 123456789;
		TransactionDao mockTranDao = mock(TransactionDao.class);
		TransactionDetailsDao mockTranDetailsDao = mock(TransactionDetailsDao.class);

		List<TransactionDetail> transactionDetails = new ArrayList<>();
		when(mockTranDetailsDao.getTransactionDetails(anyLong())).thenReturn(transactionDetails);

		Message message = TransactionService.getTransactionMessage(tranId, mockTranDao, mockTranDetailsDao);
		assertEquals(-1, message.getMessageId());
		assertEquals(true, message.getCanPostpone());
		assertEquals("", message.getState());
		assertEquals("BLANK", message.getContactName());
		assertEquals("", message.getPhoneNumber1());
		assertEquals("", message.getPhoneNumber2());
	}

	@Test
	public void testGetTransaction() throws Exception {
		final long tranId = 123456789;
		TransactionDao mockTranDao = mock(TransactionDao.class);
		TransactionDetailsDao mockTranDetailsDao = mock(TransactionDetailsDao.class);

		List<TransactionDetail> transactionDetails = Arrays.asList(
				new TransactionDetail("health/situation/state", "QLD"),
				new TransactionDetail("health/application/primary/firstname", "Firstname"),
				new TransactionDetail("health/contactDetails/contactNumber/mobile", "contactMobile"),
				new TransactionDetail("health/application/mobile", "appMobile"),
				new TransactionDetail("health/contactDetails/contactNumber/other", "contactOther"),
				new TransactionDetail("health/application/other", "appOther")
		);
		when(mockTranDetailsDao.getTransactionDetails(anyLong())).thenReturn(transactionDetails);

		Message message = TransactionService.getTransactionMessage(tranId, mockTranDao, mockTranDetailsDao);
		assertEquals("QLD", message.getState());
		assertEquals("Firstname BLANK", message.getContactName());
		assertEquals("appMobile", message.getPhoneNumber1());
		assertEquals("appOther", message.getPhoneNumber2());

		transactionDetails = Arrays.asList(
				new TransactionDetail("health/application/primary/firstname", "Firstname"),
				new TransactionDetail("health/application/primary/surname", "Surname"),
				new TransactionDetail("health/contactDetails/contactNumber/mobile", "contactMobile"),
				new TransactionDetail("health/contactDetails/contactNumber/other", "contactOther")
		);
		when(mockTranDetailsDao.getTransactionDetails(anyLong())).thenReturn(transactionDetails);
		message = TransactionService.getTransactionMessage(tranId, mockTranDao, mockTranDetailsDao);
		assertEquals("Firstname Surname", message.getContactName());
		assertEquals("contactMobile", message.getPhoneNumber1());
		assertEquals("contactOther", message.getPhoneNumber2());
	}
}