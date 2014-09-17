package com.ctm.services.email;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.SessionException;
import com.ctm.factory.EmailServiceFactory;
import com.ctm.model.email.EmailResponse;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.email.EmailServiceHandler.EmailMode;
import com.ctm.web.validation.EmailValidation;
import com.disc_au.web.go.Data;

public class EmailService {

	private static Logger logger = Logger.getLogger(EmailService.class.getName());

	SessionDataService sessionDataService;
	protected TransactionDao transactionDao;
	private EmailServiceHandler emailService;

	/**
	 * Sends a email based on the EmailMode.
	 * Failures are written to the fatal error table
	 *
	 * @param request
	 * @param mode
	 * @param emailAddress
	 * @return JSONObject whether sending email was successful
	 */
	public JSONObject send(HttpServletRequest request, EmailMode mode , String emailAddress) {
		long transactionId = Long.parseLong(request.getParameter("transactionId"));
		EmailResponse emailResponse = new EmailResponse();
		emailResponse.setTransactionId(transactionId);
		emailResponse.setSuccessful(false);
		try {
			send(request, mode , emailAddress, transactionId);
			emailResponse.setSuccessful(true);
		} catch (SendEmailException e) {
			FatalErrorService.logFatalError(e, 0, request.getRequestURI(), request.getSession().getId(), true);
			logger.error("failed to send " + mode + " to " + emailAddress, e);
			logger.error("error description " + e.getDescription());
			emailResponse.setMessage(e.getMessage());
		}
		return emailResponse.toJsonObject();
	}

	/**
	 * Sends a email based on the EmailMode.
	 * Failures are thrown with SendEmailException and it is up to the caller to handle these errors
	 *
	 * @param request
	 * @param mode
	 * @param emailAddress
	 * @param transactionId
	 */
	public void send(HttpServletRequest request, EmailMode mode,
			String emailAddress, long transactionId) throws SendEmailException {
		boolean isValid = EmailValidation.validate(emailAddress);
		if(isValid) {
			PageSettings pageSettings;
			Data data = null;
				try {
					data = SessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);
					if(data == null){
						pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.GENERIC.getCode());
					} else {
						pageSettings = SettingsService.getPageSettingsForPage(request);
					}
				} catch (DaoException | ConfigSettingException | SessionException e) {
					throw new SendEmailException("failed to get settings", e);
				}
				emailService = EmailServiceFactory.newInstance(pageSettings, mode, data);
				emailService.send(request, emailAddress, transactionId);
		} else {
			throw new SendEmailException(transactionId + ": invalid email recieved emailAddress:" +  emailAddress);
		}
	}
}
