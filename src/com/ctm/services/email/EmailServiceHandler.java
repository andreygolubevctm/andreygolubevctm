package com.ctm.services.email;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.email.EmailModel;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.EnvironmentService;
import com.ctm.services.EnvironmentService.Environment;

public abstract class EmailServiceHandler {


	protected static final  List<String> testEmails = new ArrayList<String>() {
		private static final long serialVersionUID = 1L;

	{
		add("gomez.testing@aihco.com.au");
		add("preload.testing@comparethemarket.com.au");
	}};

	public enum EmailMode {
		QUOTE{
			public String toString() {
				return "quote";
			}
		},
		APP{
			public String toString() {
				return "app";
			}
		},
		EDM{
			public String toString() {
				return "edm";
			}
		},
		BEST_PRICE{
			public String toString() {
				return "bestprice";
			}
		},
		PRODUCT_BROCHURES{
			public String toString() {
				return "brochures";
			}
		}

	}

	protected PageSettings pageSettings;
	protected EmailMode emailMode;

	protected String mailingName;

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

	protected String getMailingName(String mailingNameKey) throws SendEmailException {
		try {
			return pageSettings.getSetting(mailingNameKey);
		} catch (EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to get mailingName QuoteEmailHandler.MAILING_NAME_KEY:" +  mailingNameKey, e);
		}
	}

}
