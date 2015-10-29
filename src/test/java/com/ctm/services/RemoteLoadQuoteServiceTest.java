package com.ctm.services;

import static org.junit.Assert.*;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.transaction.TransactionDao;
import com.ctm.web.core.dao.transaction.TransactionDetailsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailMaster;
import com.ctm.web.core.model.Transaction;
import com.ctm.model.TransactionDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.Vertical.VerticalType;

public class RemoteLoadQuoteServiceTest {

	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);
	private TransactionDetailsDao transactionDetailsDao = mock(TransactionDetailsDao.class);
	private TransactionDao transactionDao = mock(TransactionDao.class);
	
	private HashedEmailService hashedEmailService;
	private RemoteLoadQuoteService remoteLoadQuoteService;
	String hashedEmail = "hashedEmail";
	String email = "test@test.com";
	int brandId = 42;
	long transactionId = 111111111111L;
	String vertical = VerticalType.CAR.getCode();
	private String type = EmailMode.APP.toString();
	
	@Before
	public void setup() throws DaoException{
		
		Transaction transaction = new Transaction();
		transaction.setEmailAddress(email);
		when(transactionDao.getCoreInformation((Transaction)anyObject())).thenReturn(transaction  );
		
		List<TransactionDetail> transactionDetails = new ArrayList<TransactionDetail>();
		transactionDetails.add(new TransactionDetail());
		hashedEmailService= new HashedEmailService(emailMasterDao);
		TransactionAccessService transactionAccessService = new TransactionAccessService(hashedEmailService, transactionDetailsDao, transactionDao);
		EmailMaster emailMaster = new EmailMaster();
		emailMaster.setEmailAddress(email);
		emailMaster.setHashedEmail(hashedEmail);
		when(emailMasterDao.getEmailMaster(email, brandId)).thenReturn(emailMaster );
		when(transactionDetailsDao.getTransactionDetails(transactionId)).thenReturn(transactionDetails );
		
		remoteLoadQuoteService = new RemoteLoadQuoteService(transactionAccessService, transactionDetailsDao);
	}

	@Test
	public void testShouldGetTransactionDetailsIfValid() throws SQLException, DaoException, EmailDetailsException {
		List<TransactionDetail> transactionDetails = remoteLoadQuoteService.getTransactionDetails(hashedEmail, vertical, type, email, transactionId, brandId);
		assertEquals(transactionDetails.size() , 1);
	}
	
	
	@Test
	public void testShouldGetTransactionDetailsIfHasSpace() throws SQLException, DaoException, EmailDetailsException {
		String emailWithPlus = "test+test@test.com";
		Transaction transaction = new Transaction();
		transaction.setEmailAddress(emailWithPlus);
		when(transactionDao.getCoreInformation((Transaction)anyObject())).thenReturn(transaction  );
		EmailMaster emailMaster = new EmailMaster();
		emailMaster.setEmailAddress(emailWithPlus);
		emailMaster.setHashedEmail(hashedEmail);
		when(emailMasterDao.getEmailMaster(emailWithPlus, brandId)).thenReturn(emailMaster );
		
		String emailWithSpace = "test test@test.com";
		List<TransactionDetail> transactionDetails = remoteLoadQuoteService.getTransactionDetails(hashedEmail, vertical, type, emailWithSpace, transactionId, brandId);
		assertEquals(transactionDetails.size() , 1);
	}
	
	@Test
	public void testShouldNotGetTransactionDetailsIfInValid() throws SQLException, DaoException, EmailDetailsException {
		String invalidEmail = "invalid@test.com";
		
		EmailMaster differentEmailMaster = new EmailMaster();
		when(emailMasterDao.getEmailMaster(invalidEmail, brandId)).thenReturn(differentEmailMaster   );

		List<TransactionDetail> transactionDetails = remoteLoadQuoteService.getTransactionDetails(hashedEmail, vertical, type, invalidEmail, transactionId, brandId);

		assertTrue(transactionDetails.isEmpty());
	}

}
