package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;

import javax.servlet.http.HttpServletRequest;


public interface BestPriceEmailHandler {

	public static String MAILING_NAME_KEY  = "sendBestPriceMailingName";
	public static String MAILING_NAME_KEY_VARIATION  = "sendBestPriceMailingNameVar";
	
	public static String OPT_IN_MAILING_NAME  = "sendBestPriceOptInMailingName";
	public static String OPT_IN_MAILING_NAME_VARIATION  = "sendBestPriceOptInMailingNameVar";
	
	public static String SPLIT_TESTING_ENABLED = "sendBestPriceSplitTestingEnabled";

	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;
}
