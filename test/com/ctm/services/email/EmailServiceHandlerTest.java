package com.ctm.services.email;

import static org.junit.Assert.*;

import javax.servlet.http.HttpServletRequest;

import org.junit.Test;

import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.PageSettings;


public class EmailServiceHandlerTest {

	private class TestEmailHandler extends EmailServiceHandler {

		public TestEmailHandler(PageSettings pageSettings, EmailMode emailMode) {
			super(pageSettings, emailMode);
		}

		@Override
		public void send(HttpServletRequest request, String emailAddress,
				long transactionId) {
		}

		public boolean protectedIsTestEmailAddress(String emailAddress) {
			return super.isTestEmailAddress(emailAddress);
		}

	}

	@Test
	public void testShoouldFilterOutTestEmails() {
		TestEmailHandler testEmailHandler = new TestEmailHandler(null, null);
		boolean isTestEmailAddress = testEmailHandler.protectedIsTestEmailAddress("gomez.testing@aihco.com.au");
		assertTrue(isTestEmailAddress);

		isTestEmailAddress = testEmailHandler.protectedIsTestEmailAddress("Sergie.Meerkat@comparethemarket.com.au");
		assertFalse(isTestEmailAddress);
	}

}
