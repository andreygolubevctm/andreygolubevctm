package com.ctm.services;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailMaster;
import com.ctm.model.Transaction;
import com.ctm.model.TransactionDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.Vertical.VerticalType;

import static com.ctm.services.TransactionAccessService.HEALTH_BEST_PRICE_EMAIL_XPATH;


public class TransactionAccessServiceTest {
	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);
	private TransactionDetailsDao transactionDetailsDao = mock(TransactionDetailsDao.class);
	private TransactionDao transactionDao = mock(TransactionDao.class);
	
	private HashedEmailService hashedEmailService;
	String hashedEmail = "hashedEmail";
	String emailAddress = "test@test.com";
	int brandId = 42;
	long transactionId = 111111111111L;
	VerticalType vertical = VerticalType.HEALTH;
	EmailMode type = EmailMode.BEST_PRICE;
	private TransactionAccessService transactionAccessService;
	private EmailMode emailMode = EmailMode.APP;
	private VerticalType verticalType = VerticalType.CAR;
	private Transaction transaction;
	private IncomingEmail emailData;
	
	@Before
	public void setup() throws DaoException{
		List<TransactionDetail> transactionDetails = new ArrayList<TransactionDetail>();
		transactionDetails.add(new TransactionDetail());
		hashedEmailService= new HashedEmailService(emailMasterDao);
		transactionAccessService = new TransactionAccessService(hashedEmailService, transactionDetailsDao, transactionDao);
		emailData = new IncomingEmail();
		emailData.setEmailAddress(emailAddress);
		emailData.setEmailHash(hashedEmail);
		emailData.setEmailType(emailMode);
		emailData.setTransactionId(transactionId);
		when(emailMasterDao.getEmailMaster(emailAddress, brandId)).thenReturn(emailData.getEmailMaster() );
		when(transactionDetailsDao.getTransactionDetails(transactionId)).thenReturn(transactionDetails );
		transaction = new Transaction();
		transaction.setEmailAddress(emailAddress);
		when(transactionDao.getCoreInformation((Transaction)anyObject())).thenReturn(transaction  );
	}

	@Test
	public void testShouldNotHaveAccess() throws SQLException, DaoException, EmailDetailsException {
		String invalidEmail = "invalid@test.com";
		emailData.setEmailAddress(invalidEmail);
		EmailMaster differentEmailMaster = new EmailMaster();
		when(emailMasterDao.getEmailMaster(invalidEmail, brandId)).thenReturn(differentEmailMaster  );
		boolean hasAccess = transactionAccessService.hasAccessToTransaction(emailData, brandId , verticalType);
		assertFalse(hasAccess);
	}
	

	@Test
	public void testShouldNotHaveAccessIfHealthAndNoMatch() throws SQLException, DaoException, EmailDetailsException {
		emailData.setEmailAddress(emailAddress);
		TransactionDetail transactionDetail = new TransactionDetail();
		transactionDetail.setTextValue(emailAddress);
		when(transactionDetailsDao.getTransactionDetailByXpath(transactionId, HEALTH_BEST_PRICE_EMAIL_XPATH)).thenReturn(transactionDetail);
		emailData.setEmailType(EmailMode.BEST_PRICE);
		boolean hasAccess = transactionAccessService.hasAccessToTransaction(emailData, brandId , VerticalType.HEALTH);
		assertTrue(hasAccess);
		
		emailData.setEmailAddress(emailAddress);
		transactionDetail = new TransactionDetail();
		transactionDetail.setTextValue("test2@test.com");
		when(transactionDetailsDao.getTransactionDetailByXpath(transactionId, HEALTH_BEST_PRICE_EMAIL_XPATH)).thenReturn(transactionDetail);
		emailData.setEmailType(EmailMode.BEST_PRICE);
		hasAccess = transactionAccessService.hasAccessToTransaction(emailData, brandId, VerticalType.HEALTH);
		assertFalse(hasAccess);
	}
	
	@Test
	public void testShouldHaveAccess() throws SQLException, DaoException, EmailDetailsException {
		boolean hasAccess = transactionAccessService.hasAccessToTransaction(emailData, brandId, verticalType);
		assertTrue(hasAccess);
	}
}
