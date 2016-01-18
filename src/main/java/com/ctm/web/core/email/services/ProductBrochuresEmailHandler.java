package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;

import javax.servlet.http.HttpServletRequest;

public interface ProductBrochuresEmailHandler {

	public static String MAILING_NAME_KEY  = "sendProductBrochuresMailingName";

	public void sendProductBrochureEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;
}
