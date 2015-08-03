package com.ctm.services.email;

import javax.servlet.http.HttpServletRequest;

import com.ctm.exceptions.SendEmailException;

public interface ProductBrochuresEmailHandler {

	public static String MAILING_NAME_KEY  = "sendProductBrochuresMailingName";

	public void sendProductBrochureEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;
}
