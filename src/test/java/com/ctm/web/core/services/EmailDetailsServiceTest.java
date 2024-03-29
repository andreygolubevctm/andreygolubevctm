package com.ctm.web.core.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import org.junit.Before;
import org.junit.Test;

import java.sql.SQLException;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class EmailDetailsServiceTest {

	private String operator = "ONLINE";
	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);
	private TransactionDao transactionDao = mock(TransactionDao.class);
	private StampingDao stampingDao = mock(StampingDao.class);
	private long transactionId = 1234567;
	private String vertical = "test";

	private String requestFirstName = "requestFirstName";
	private String requestLastName = "requestLastName";

	private String dataBucketFirstName = "dataBucketFirstName";
	private String dataBucketLastName = "dataBucketLastName";

	private String databaseFirstName = "databaseFirstName";
	private String databaseLastName = "databaseLastName";

	private String emailAddress = "emailAddress";
	private EmailDetailsService emailDetailsService;
	private Data data;
	private EmailMaster emailDetailsRequest;

	private String brandCode = "TestBrand";
	private EmailMaster emailDetailsDB;

	@Before
	public void setup() throws DaoException{
		emailDetailsRequest = createRequestEmailDetails();
		data = new Data();
		data.put("health/application/primary/firstname", dataBucketFirstName);
		data.put("health/application/primary/surname", dataBucketLastName);
		EmailDetailsMappings emailDetailMappings = new HealthEmailDetailMappings();
		emailDetailsService = new EmailDetailsService(emailMasterDao, transactionDao, data ,
				brandCode , emailDetailMappings, stampingDao, vertical);

		emailDetailsDB = createDabaseEmailDetails();
		when(emailMasterDao.getEmailDetails(emailAddress)).thenReturn(emailDetailsDB);
	}

	@Test
	public void testShouldPopulateLastName () throws SQLException, DaoException, EmailDetailsException {

		EmailMaster emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, brandCode);
		assertEquals(requestFirstName, emailDetails.getFirstName());
		assertEquals(requestLastName, emailDetails.getLastName());

		//from data bucket
		emailDetailsRequest = new EmailMaster();
		emailDetailsRequest.setFirstName("");
		emailDetailsRequest.setLastName("");
		emailDetailsRequest.setEmailAddress(emailAddress);

		emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, brandCode);
		assertEquals(dataBucketFirstName, emailDetails.getFirstName());
		assertEquals(dataBucketLastName, emailDetails.getLastName());

		//from database
		emailDetailsRequest = new EmailMaster();
		emailDetailsRequest.setFirstName("");
		emailDetailsRequest.setLastName("");
		emailDetailsRequest.setEmailAddress(emailAddress);

		data.put("health/application/primary/firstname", "");
		data.put("health/application/primary/surname", "");

		emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, brandCode);
		assertEquals(databaseFirstName, emailDetails.getFirstName());
		assertEquals(databaseLastName, emailDetails.getLastName());

	}

	@Test
	public void testHandleNotOptedInDB() throws SQLException, DaoException, EmailDetailsException {
		emailDetailsDB.setOptedInMarketing(false, vertical);

		emailDetailsRequest.setOptedInMarketing(false, vertical);
		emailDetailsRequest.setSource("");
		EmailMaster result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertFalse(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(1)).add(eq("toggle_marketing") , eq(emailAddress) , eq("off"),  eq(operator),  anyString(), anyString());

		emailDetailsRequest.setOptedInMarketing(true, vertical);
		result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertTrue(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(1)).add(eq("toggle_marketing"), eq(emailAddress), eq("on"), eq(operator),  anyString(), anyString());

	}

	@Test
	public void testHandleOptedInForDB() throws SQLException, DaoException, EmailDetailsException {
		emailDetailsDB.setOptedInMarketing(true, vertical);

		emailDetailsRequest.setOptedInMarketing(true, vertical);
		emailDetailsRequest.setSource("");
		EmailMaster result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertTrue(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(0)).add(eq("toggle_marketing"), eq(emailAddress) , eq(operator), eq("on"), anyString(), anyString());

		emailDetailsRequest.setOptedInMarketing(false, vertical);
		result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertTrue(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(0)).add(eq("toggle_marketing"), eq(emailAddress) , eq(operator), eq("on"), anyString(), anyString());

	}


	@Test
	public void testHandleAddingEmailToDB() throws SQLException, DaoException, EmailDetailsException {

		String emailAddress= "test@gmail.com";
		EmailMaster emailMasterAdded = new EmailMaster();
		int expectedEmailId = 10;
		emailMasterAdded.setEmailId(10);
		emailMasterAdded.setEmailAddress(emailAddress);
		when(emailMasterDao.writeEmailDetails((EmailMaster) anyObject())).thenReturn(emailMasterAdded);

		String emailPassword = "";
		String source = "";
		String firstName = "";
		String lastName = "";
		String transactionIdString = "";
		int emailId = emailDetailsService.handleWriteEmailDetailsFromJsp(emailAddress, emailPassword, source, firstName,
				lastName, transactionIdString);

		assertEquals(expectedEmailId, emailId);

	}

	@Test
	public void testHandleNotInDB() throws SQLException, DaoException, EmailDetailsException {

		when(emailMasterDao.getEmailDetails(emailAddress)).thenReturn(null);

		// handle not opted in database
		emailDetailsRequest.setOptedInMarketing(false, vertical);
		EmailMaster emailDetailsDB = createDabaseEmailDetails();
		emailDetailsDB.setOptedInMarketing(false, vertical);
		when(emailMasterDao.writeEmailDetails((EmailMaster)anyObject())).thenReturn(emailDetailsDB);

		emailDetailsRequest.setOptedInMarketing(false, vertical);
		EmailMaster result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertFalse(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(1)).add(eq("toggle_marketing") ,eq(emailAddress) , eq("off"), eq(operator), anyString(), anyString());

		emailDetailsRequest.setOptedInMarketing(true, vertical);
		emailDetailsDB.setOptedInMarketing(true, vertical);
		when(emailMasterDao.writeEmailDetails((EmailMaster)anyObject())).thenReturn(emailDetailsDB);

		result = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetailsRequest, operator, "");
		assertTrue(result.getOptedInMarketing(vertical));

		verify(stampingDao, times(1)).add(eq("toggle_marketing") ,eq(emailAddress) , eq("on"), eq(operator),  anyString(), anyString());

	}

	private EmailMaster createRequestEmailDetails() {
		EmailMaster emailDetailsRequest = new EmailMaster();
		emailDetailsRequest.setFirstName(requestFirstName);
		emailDetailsRequest.setLastName(requestLastName);
		emailDetailsRequest.setEmailAddress(emailAddress);
		emailDetailsRequest.setOptedInMarketing(true, vertical);
		return emailDetailsRequest;
	}

	private EmailMaster createDabaseEmailDetails() {
		EmailMaster emailDetailsDB = new EmailMaster();
		emailDetailsDB.setFirstName(databaseFirstName);
		emailDetailsDB.setLastName(databaseLastName);
		emailDetailsDB.setOptedInMarketing(true, vertical);
		return emailDetailsDB;
	}

}
