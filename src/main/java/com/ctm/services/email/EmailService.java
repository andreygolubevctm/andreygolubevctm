package com.ctm.services.email;

import javax.servlet.http.HttpServletRequest;

import com.ctm.utils.RequestUtils;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.SessionException;
import com.ctm.factory.EmailServiceFactory;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.EmailResponse;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.FatalErrorService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.web.validation.EmailValidation;
import com.disc_au.web.go.Data;

public class EmailService {

	private static final Logger logger = LoggerFactory.getLogger(EmailService.class.getName());

	private final SessionDataService sessionDataService = new SessionDataService();
	private final FatalErrorService fatalErrorService;
	protected TransactionDao transactionDao;
	private PageSettings pageSettings;

	public EmailService(){
		fatalErrorService = new FatalErrorService();
	}

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
		fatalErrorService.sessionId  = request.getSession().getId();
		fatalErrorService.page = request.getRequestURI();
		Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
		fatalErrorService.transactionId = transactionId;
		EmailResponse emailResponse = new EmailResponse();
		emailResponse.setTransactionId(transactionId);
		emailResponse.setSuccessful(false);
		try {
			send(request, mode , emailAddress, transactionId);
			emailResponse.setSuccessful(true);
		} catch (SendEmailException e) {
			fatalErrorService.logFatalError(e, "failed to send " + mode + " to " + emailAddress, true);
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
			Data data = null;
				try {
					if(transactionId > 0) {
						try {
							data = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);
						} catch (SessionException e) {
							logger.warn(e.getMessage());
						}
					}
					if(data == null) {
						String vertical = request.getParameter("vertical");
						if(vertical == null || vertical.isEmpty()){
							logger.info("defaulting to generic vertical");
							vertical = VerticalType.GENERIC.getCode();
						} else {
							vertical = vertical.toUpperCase();
						}
						pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, vertical);
					} else {
						pageSettings = SettingsService.getPageSettingsForPage(request);
					}
					fatalErrorService.styleCodeId = pageSettings.getBrandId();
					if(pageSettings.getBrandCode() != null){
						fatalErrorService.property = pageSettings.getBrandCode().toLowerCase();
					}
				} catch (DaoException | ConfigSettingException  e) {
					throw new SendEmailException("failed to get settings", e);
				}
			EmailServiceHandler emailService = EmailServiceFactory.newInstance(pageSettings, mode, data);
			emailService.send(request, emailAddress, transactionId);
		} else {
			throw new SendEmailException(transactionId + ": invalid email recieved emailAddress:" +  emailAddress);
		}
	}
}
