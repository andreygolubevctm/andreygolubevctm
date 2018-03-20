package com.ctm.web.core.services;

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
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.model.settings.Vertical.VerticalType;

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

	@Test
	public void testGetActionQuoteUrl() throws Exception {
		String action = "test";
		String jParam = "&amp;test=true";
		assertEquals("car_quote.jsp?action=test&amp;transactionId=111111111111&amp;test=true" , remoteLoadQuoteService.getActionQuoteUrl( vertical ,  action ,  transactionId ,  jParam, ""));
	}

	@Test
	public void testGetLatestQuoteUrl() throws Exception {
		String jParam = "&amp;test=true";
		assertEquals("car_quote.jsp?action=latest&amp;transactionId=111111111111&amp;test=true" , remoteLoadQuoteService.getLatestQuoteUrl( vertical  ,  transactionId ,  jParam, ""));
	}

	@Test
	public void testGetStartAgainQuoteUrl() throws Exception {
		String jParam = "&amp;test=true";
		assertEquals("car_quote.jsp?action=start-again&amp;transactionId=111111111111&amp;test=true" , remoteLoadQuoteService.getStartAgainQuoteUrl( vertical  ,  transactionId ,  jParam, ""));
	}
}
