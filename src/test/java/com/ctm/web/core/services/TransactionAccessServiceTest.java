package com.ctm.web.core.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.services.TransactionAccessService.HEALTH_BEST_PRICE_EMAIL_XPATH;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;


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
