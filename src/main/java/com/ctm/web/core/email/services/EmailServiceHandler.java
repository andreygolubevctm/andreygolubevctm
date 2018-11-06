package com.ctm.web.core.email.services;

import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.EmailModel;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.EnvironmentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public abstract class EmailServiceHandler {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailServiceHandler.class);


	protected static final  List<String> testEmails = new ArrayList<String>() {
		private static final long serialVersionUID = 1L;

	{
		add("gomez.testing@aihco.com.au");
		add("preload.testing@comparethemarket.com.au");
	}};


	protected PageSettings pageSettings;
	protected EmailMode emailMode;

	protected String mailingName;
	protected String splitTestEnabledKey;
	protected IPAddressHandler ipAddressHandler;

	public EmailServiceHandler(PageSettings pageSettings, EmailMode emailMode, IPAddressHandler ipAddressHandler) {
		this.pageSettings = pageSettings;
		this.emailMode = emailMode;
		this.ipAddressHandler = ipAddressHandler;
	}

	public abstract String send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;

	/**
	 * This 2nd send method is overloaded (extra productId param) and is overridden
	 * in HealthEmailService. It has not been declared as abstract as it's presently
	 * unique to health and is not needed anywhere else that implements this class.
	 */
	public String send(HttpServletRequest request, String emailAddress,
		   	long transactionId, long productId) throws SendEmailException {
		return null;
	}


	public static boolean isTestEmailAddress(String emailAddress){
		return testEmails.contains(emailAddress);
	}

	protected void setCustomerKey(EmailModel emailModel, String mailingName) {
		setCustomerKey(emailModel, mailingName, true);
	}

	protected void setCustomerKey(EmailModel emailModel, String mailingName, Boolean prefixCustomerKey) {
		String key;

		if(prefixCustomerKey) {
		if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.PRO){
				key = pageSettings.getBrandCode().toUpperCase() + "_" + mailingName;
		} else {
				key = "QA_" + pageSettings.getBrandCode().toUpperCase() + "_" + mailingName;
		}
		} else {
			key = mailingName;
	}

		emailModel.setCustomerKey(key);
	}

	protected String getSplitTestMailingName(String mailingKey, String mailingKeyVariation, String splitTest) throws SendEmailException {
		if(getPageSetting(splitTestEnabledKey).equals("Y")) {
			if(splitTest != null && splitTest.equals("2")) {
				mailingKey = mailingKeyVariation;
			}
		}
		return  getPageSetting(mailingKey);
	}

	protected String getPageSetting(String key) throws SendEmailException {
		try {
			return pageSettings.getSetting(key);
		} catch (EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to get pageSetting QuoteEmailHandler.key:" +  key, e);
		}
	}

	protected void buildEmailModel(EmailMaster emailDetails, EmailModel emailModel) {
		emailModel.setEmailAddress(emailDetails.getEmailAddress());
		try {
			emailModel.setImageUrlPrefix(getPageSetting("imageUrlPrefix"));
		} catch (SendEmailException e) {
			LOGGER.error("imageUrlPrefix not found {}", kv("emailModel", emailModel));
		}
		emailModel.setBrand(pageSettings.getBrandCode());
	}

}
