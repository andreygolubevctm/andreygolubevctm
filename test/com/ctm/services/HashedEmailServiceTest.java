package com.ctm.services;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;

import org.junit.Test;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailMaster;

public class HashedEmailServiceTest {

	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);

	@Test
	public void testShouldGetEmailMaster() throws SQLException, DaoException, EmailDetailsException {
		String hashedEmail = "hashedEmail";
		String invalidHashedEmail = "hashedEmail2";
		String target = "test@test.com";

		HashedEmailService hashedEmailService = new HashedEmailService(emailMasterDao);

		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setHashedEmail(hashedEmail);
		when(emailMasterDao.getEmailMaster(target)).thenReturn(emailDetails  );

		EmailMaster result = hashedEmailService.getEmailDetails(hashedEmail, target, 1);
		assertTrue(result.isValid());

		result = hashedEmailService.getEmailDetails(invalidHashedEmail, target, 1);

		assertFalse(result.isValid());

	}

	@Test
	public void testShouldGetEmailMasterNoEmail() throws SQLException, DaoException, EmailDetailsException {
		HashedEmailService hashedEmailService = new HashedEmailService(emailMasterDao);
		String target = null;

		String hashedEmail = "hashedEmail";
		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setEmailAddress("test@test.com");
		emailDetails.setHashedEmail(hashedEmail);
		emailDetails.setEmailId(100);
		when(emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail)).thenReturn(emailDetails  );
		EmailMaster result = hashedEmailService.getEmailDetails(hashedEmail, target, 1);
		assertTrue(result.isValid());

		String hashedEmail2 = "hashedEmail2";
		EmailMaster emailDetails2 = new EmailMaster();
		when(emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail2)).thenReturn(emailDetails2);
		result = hashedEmailService.getEmailDetails(hashedEmail2, target, 1);

		assertFalse(result.isValid());

	}


}
