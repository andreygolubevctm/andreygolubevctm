package com.ctm.services;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import com.ctm.model.FormValidationLog;

import com.ctm.web.core.constants.PrivacyBlacklist;
import com.ctm.web.core.dao.FormValidationDao;
import com.ctm.web.core.dao.transaction.TransactionDetailsDao;
import com.ctm.web.core.exceptions.DaoException;

public class FormValidationService {

	public FormValidationService() {
	}

	public void logValidationMessage(HttpServletRequest request, Long transactionId) throws DaoException {
		FormValidationDao formValidationDao = new FormValidationDao();

		String stepId = request.getParameter("stepId");

		/**
		 * Retrieve the parameter names as an Enumerated array of strings to iterate over.
		 */
		Enumeration<String> parameterNames = request.getParameterNames();

		boolean hasCheckedPrivacyOptin = (request.getParameter("hasPrivacyOptin") != null && request.getParameter("hasPrivacyOptin").equals("true"));

		while (parameterNames.hasMoreElements()) {

			/**
			 * Get the current parameter name.
			 * Ignore tranid
			 */
			String paramName = parameterNames.nextElement();

			if(paramName.equals("transactionId")) {
				continue;
			}

			/**
			 * Convert from a parameter to an XPath.
			 */
			String xpath = paramName.replace("_", "/");
			if(xpath.length() > 127) {
				xpath = xpath.substring(0,127);
			}

			if(TransactionDetailsDao.isBlacklisted(xpath)) {
				continue;
			}

			/**
			 * ParamValue comes in as inputValue::message
			 */
			String paramValue = request.getParameter(paramName).trim();
			if(!paramValue.contains("::")) {
				continue;
			}
			String[] values = paramValue.split("::");

			String inputValue = values[0];
			if(inputValue.length() > 999) {
				inputValue = inputValue.substring(0,999);
			}

			if(!hasCheckedPrivacyOptin && inputValue.length() > 1) {
				inputValue = maskPrivateFields(xpath, inputValue);
			}

			String message = values[1];
			if(message.length() > 499) {
				message = message.substring(0,499);
			}

			FormValidationLog formValidation = new FormValidationLog();
			formValidation.setXPath(xpath);
			formValidation.setValidationMessage(message);
			formValidation.setTextValue(inputValue);
			formValidation.setStepId(stepId);

			formValidationDao.addValidationLog(formValidation, transactionId);
		}

	}

	/**
	 * Mask private data fields.
	 * @param xpath
	 * @param paramValue
	 * @return String paramValue masked or not masked.
	 */
	private String maskPrivateFields(String xpath, String paramValue) {
		for(String xpathToCheck : PrivacyBlacklist.PERSONALLY_IDENTIFIABLE_INFORMATION_BLACKLIST) {
			if(xpath.contains(xpathToCheck)) {
				int endIndex =  paramValue.length() / 2;
				String stringA = paramValue.substring(0, endIndex);
				String stringB = paramValue.substring(endIndex, paramValue.length()).replaceAll("\\w", "*");
				return stringA + stringB ;
			}
		}
		return paramValue;
	}

}
