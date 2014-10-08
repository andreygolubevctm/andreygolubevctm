package com.ctm.services;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

import java.sql.SQLException;

import org.junit.Test;

import com.ctm.dao.StampingDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailMaster;
import com.ctm.model.Stamping;

public class StampingServiceTest {

	private StampingDao stampingDao = mock(StampingDao.class);

	@Test
	public void testStampMarketing() throws SQLException, DaoException, EmailDetailsException {
		String target = "test@test.com";
		String source = "test";

		StampingService stampingService = new StampingService(stampingDao);
		Stamping responseOff = new Stamping();
		responseOff.setValue("off");
		Stamping responseOn = new Stamping();
		responseOn.setValue("on");

		when(stampingDao.add("toggle_marketing", target, "off", "", source, "")).thenReturn(responseOff );
		when(stampingDao.add("toggle_marketing", target, "on", "", source, "")).thenReturn(responseOn );

		EmailMaster emailDetailsRequest = new EmailMaster();
		emailDetailsRequest.setEmailAddress(target );
		emailDetailsRequest.setSource(source);
		Stamping result = stampingService.writeOptInMarketing(emailDetailsRequest, "", true, "");
		assertEquals(result.getValue(), "on");

		Stamping resultOff = stampingService.writeOptInMarketing(emailDetailsRequest, "", false, "");
		assertEquals(resultOff.getValue(), "off");

	}

}
