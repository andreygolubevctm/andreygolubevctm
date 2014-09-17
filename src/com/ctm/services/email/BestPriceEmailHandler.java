package com.ctm.services.email;

import javax.servlet.http.HttpServletRequest;

import com.ctm.exceptions.SendEmailException;

public interface BestPriceEmailHandler {

	public static String MAILING_NAME_KEY  = "sendBestPriceMailingName";
	public static String OPT_IN_MAILING_NAME  = "sendBestPriceOptInMailingName";

	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;
}
