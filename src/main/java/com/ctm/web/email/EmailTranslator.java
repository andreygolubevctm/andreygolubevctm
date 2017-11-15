package com.ctm.web.email;

import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.web.go.Data;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;

/**
 * Created by akhurana on 26/09/17.
 */
public interface EmailTranslator {
    public static final String EMAIL_TYPE = "bestprice";
    void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException, GeneralSecurityException;
    void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws ConfigSettingException, DaoException;
}
