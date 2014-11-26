package com.ctm.services.email;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.junit.Test;

import com.ctm.exceptions.SendEmailException;
import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.PageSettings;


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
		
		String splitTest = "A";
		String mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingKey , mailingNameResult);
		
		
		splitTest = "B";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKeyVariation);
		
		
		// Split test is turned off
		testEmailHandler.pageSettings.put("splitTestEnabled", "N");
		
		splitTest = "A";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKey);
		
		
		splitTest = "B";
		mailingNameResult = testEmailHandler.protectedGetSplitTestMailingName(mailingKey, mailingKeyVariation, splitTest );
		assertEquals(mailingNameResult , mailingKey);
	}

}
