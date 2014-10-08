package com.ctm.services;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.sql.SQLException;

import org.junit.Test;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailMaster;
import com.ctm.model.Unsubscribe;
import com.ctm.model.settings.PageSettings;

public class UnsubscribeServiceTest {

	private EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);

	@Test
	public void testShouldUnsubscribe() throws SQLException, DaoException, EmailDetailsException {
		String vertical = "vertical";
		String hashedEmail = "hashedEmail";
		PageSettings pageSettings = new PageSettings();
		String target = "test@test.com";

		UnsubscribeService unsubscribeService = new UnsubscribeService(emailMasterDao);

		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setHashedEmail(hashedEmail);
		when(emailMasterDao.getEmailMaster(target)).thenReturn(emailDetails  );

		Unsubscribe unsubscribe = new Unsubscribe();
		unsubscribe.setEmailDetails(emailDetails);
		unsubscribe.setVertical(vertical);
		unsubscribeService.unsubscribe(pageSettings, unsubscribe );
		verify(emailMasterDao).writeToEmailProperties(emailDetails);

		unsubscribe = new Unsubscribe();
		unsubscribe.setVertical(null);
		unsubscribe.setEmailDetails(emailDetails);
		unsubscribeService.unsubscribe(pageSettings, unsubscribe);

		verify(emailMasterDao).writeToEmailPropertiesAllVerticals(emailDetails);

	}


}
