package com.ctm.web.core.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.Unsubscribe;
import com.ctm.web.core.model.settings.PageSettings;
import org.junit.Test;

import java.sql.SQLException;

import static org.mockito.Mockito.*;

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
