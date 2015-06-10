package com.ctm.services.email;

import com.ctm.exceptions.SendEmailException;
import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.PageSettings;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.*;


public class EmailServiceHandlerTest {

	private class TestEmailHandler extends EmailServiceHandler {

		public Map<String , String> pageSettings = new HashMap<String , String> ();

		public TestEmailHandler(PageSettings pageSettings, EmailMode emailMode) {
			super(pageSettings, emailMode);
			splitTestEnabledKey = "splitTestEnabled";
		}

		@Override
		public void send(HttpServletRequest request, String emailAddress,
						 long transactionId) {
		}

		public boolean protectedIsTestEmailAddress(String emailAddress) {
			return super.isTestEmailAddress(emailAddress);
		}

		public String protectedGetSplitTestMailingName(String mailingKey, String mailingKeyVariation, String splitTest) throws SendEmailException {
			return super.getSplitTestMailingName( mailingKey, mailingKeyVariation, splitTest);
		}

		@Override
		public String getPageSetting(String key) throws SendEmailException {
			return pageSettings.get(key);
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

	@Test
	public void testShouldGetSplitTestMailingName() throws SendEmailException {
		String mailingKey = "mailingKey";
		String mailingKeyVariation = "mailingKeyVariation";

		// Split test is turned on
		TestEmailHandler testEmailHandler = new TestEmailHandler(null, null);
		testEmailHandler.pageSettings.put("splitTestEnabled", "Y");
		testEmailHandler.pageSettings.put(mailingKey, "mailingKey");
		testEmailHandler.pageSettings.put(mailingKeyVariation, "mailingKeyVariation");

		String splitTest = "1";
		String mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingKey , mailingNameResult);


		splitTest = "2";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKeyVariation);


		// Split test is turned off
		testEmailHandler.pageSettings.put("splitTestEnabled", "N");

		splitTest = "1";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKey);


		splitTest = "2";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKey);
	}

}
