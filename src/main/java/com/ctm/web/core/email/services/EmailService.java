package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.EmailResponse;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.EmailValidation;
import com.ctm.web.core.web.Utils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.factory.EmailServiceFactory;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class EmailService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailService.class);

	private final SessionDataService sessionDataService = new SessionDataService();
	private final FatalErrorService fatalErrorService;
	private  EmailServiceFactory emailServiceFactory;
	private PageSettings pageSettings;

	@Deprecated
	public EmailService(){
		fatalErrorService = new FatalErrorService();
	}

    @Deprecated
    private void init(ServletContext sc) {
        final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(sc);
        this.emailServiceFactory = applicationContext.getBean(EmailServiceFactory.class);
    }

    @Autowired
	public EmailService(EmailServiceFactory emailServiceFactory){
		fatalErrorService = new FatalErrorService();
		this.emailServiceFactory = emailServiceFactory;
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
			LOGGER.error("failed to send email {}, {}", kv("mode", mode), kv("emailAddress", emailAddress), e);
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
    @Deprecated
    public void sendJsp(HttpServletRequest request, EmailMode mode,
                     String emailAddress, long transactionId) throws SendEmailException {
        init(request.getServletContext());
        this.send( request,  mode,emailAddress,  transactionId);

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
			Utils.createBPTouches(transactionId, Touch.TouchType.BP_EMAIL_STARTED, emailAddress,false);
			Data data = null;
				try {
					if(transactionId > 0) {
						try {
							data = sessionDataService.getDataForTransactionId(request, String.valueOf(transactionId), false);
						} catch (SessionException e) {
							LOGGER.warn("Failed to get session data {}, {}, {}", kv("mode", mode), kv("emailAddress", emailAddress),
								kv("transactionId", transactionId), e);
						}
					}
					if(data == null) {
						String vertical = request.getParameter("vertical");
						if(vertical == null || vertical.isEmpty()){
							LOGGER.debug("Defaulting to generic vertical {}, {}, {}", kv("mode", mode), kv("emailAddress", emailAddress),
								kv("transactionId", transactionId));
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

			EmailServiceHandler emailService = this.emailServiceFactory.newInstance(pageSettings, mode, data);
			emailService.send(request, emailAddress, transactionId);
			Utils.createBPTouches(transactionId, Touch.TouchType.BP_EMAIL_END, emailAddress,false);
		} else {
			LOGGER.info("BPEMAIL Email Validation failed, skipping send.");
			throw new SendEmailException(transactionId + ": invalid email received emailAddress:" +  emailAddress);
		}

	}
}
