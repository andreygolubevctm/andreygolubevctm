package com.ctm.services.email;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.EmailMaster;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.EmailModel;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.EnvironmentService;
import com.ctm.services.EnvironmentService.Environment;

public abstract class EmailServiceHandler {

	private static Logger logger = Logger.getLogger(EmailServiceHandler.class.getName());


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

	public EmailServiceHandler(PageSettings pageSettings, EmailMode emailMode) {
		this.pageSettings = pageSettings;
		this.emailMode = emailMode;
	}

	public abstract void send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException;

	protected boolean isTestEmailAddress(String emailAddress){
		return testEmails.contains(emailAddress);
	}

	protected void setCustomerKey(EmailModel emailModel, String mailingName) {
		if(EnvironmentService.getEnvironment() == Environment.PRO){
			emailModel.setCustomerKey(pageSettings.getBrandCode().toUpperCase() + "_" + mailingName);
		} else {
			emailModel.setCustomerKey("QA_" + pageSettings.getBrandCode().toUpperCase() + "_" + mailingName);
		}
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

	protected void buildEmailModel(EmailMaster emailDetails,
			EmailModel emailModel) {
		emailModel.setEmailAddress(emailDetails.getEmailAddress());
		try {
			emailModel.setImageUrlPrefix(getPageSetting("imageUrlPrefix"));
		} catch (SendEmailException e) {
			logger.info("imageUrlPrefix not found");
		}
		emailModel.setBrand(pageSettings.getBrandCode());
	}

}
