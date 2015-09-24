package com.ctm.services.email;

import com.ctm.exceptions.SendEmailException;

import javax.servlet.http.HttpServletRequest;

public interface ApplicationEmailHandler {

    String MAILING_NAME_KEY  = "sendAppMailingName";

    String sendApplicationEmail(HttpServletRequest request, String emailAddress,
                                  long transactionId) throws SendEmailException;

}
