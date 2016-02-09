package com.ctm.web.core.services;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.sql.SQLException;

import org.junit.Test;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.model.EmailMaster;

public class HashedEmailServiceTest {

	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);
	private int brandId = 1;

	@Test
	public void testShouldGetEmailMaster() throws SQLException, DaoException, EmailDetailsException {
		String hashedEmail = "hashedEmail";
		String invalidHashedEmail = "hashedEmail2";
		String target = "test@test.com";

		HashedEmailService hashedEmailService = new HashedEmailService(emailMasterDao);

		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setHashedEmail(hashedEmail);
		when(emailMasterDao.getEmailMaster(target, brandId )).thenReturn(emailDetails  );

		EmailMaster result = hashedEmailService.getEmailDetails(hashedEmail, target, brandId);
		assertTrue(result != null && result.isValid());

		result = hashedEmailService.getEmailDetails(invalidHashedEmail, target, brandId);

		assertFalse(result != null && result.isValid());

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
		when(emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail, brandId)).thenReturn(emailDetails  );
		EmailMaster result = hashedEmailService.getEmailDetails(hashedEmail, target, brandId);
		assertTrue(result != null && result.isValid());

		String hashedEmail2 = "hashedEmail2";
		EmailMaster emailDetails2 = new EmailMaster();
		when(emailMasterDao.getEmailMasterFromHashedEmail(hashedEmail2, brandId)).thenReturn(emailDetails2);

		result = hashedEmailService.getEmailDetails(hashedEmail2, target, brandId);

		assertFalse(result != null && result.isValid());

	}


}
