package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;

import javax.servlet.http.HttpServletRequest;

public interface ApplicationEmailHandler {

    String MAILING_NAME_KEY  = "sendAppMailingName";

    String sendApplicationEmail(HttpServletRequest request, String emailAddress,
                                  long transactionId, long productId) throws SendEmailException;

}
