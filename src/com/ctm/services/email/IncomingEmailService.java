package com.ctm.services.email;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.log4j.Logger;

import com.ctm.dao.ResultsDao;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.TransactionProperties;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;
import com.ctm.services.TransactionAccessService;

public class IncomingEmailService {

	private static Logger logger = Logger.getLogger(IncomingEmailService.class.getName());

	/**
	 * Create a URL for viewing a confirmation that is brand and vertical aware.
	 *
	 * @param confirmationKey
	 * @return confirmationUrl
	 */
	public String getRedirectionUrl(IncomingEmail emailData) {

		StringBuilder redirectionUrl = new StringBuilder();

		ResultsDao resultsDao = new ResultsDao();

		try {

			// Get the related transaction details (brand, vertical)
			TransactionDao transactionDao = new TransactionDao();
			TransactionProperties transactionProps = new TransactionProperties();
			transactionProps.setTransactionId(emailData.getTransactionId());
			transactionDao.getCoreInformation(transactionProps);

			// Get the relevant brand+vertical settings
			PageSettings pageSettings = SettingsService.getPageSettings(transactionProps.getStyleCodeId(), transactionProps.getVerticalCode());

			// Get EmailMasterDao for verifying access to transaction
			TransactionAccessService transactionAccessService = new TransactionAccessService();

			if(transactionAccessService.hasAccessToTransaction(emailData , transactionProps.getStyleCodeId(), pageSettings.getVertical().getType())) {

				// Get latest results properties for specific product
				ArrayList<ResultProperty> resultData = resultsDao.getResultPropertiesForTransaction(emailData.getTransactionId(), emailData.getProductId());

				EmailUrlService emailUrlService = new EmailUrlService(pageSettings.getVertical().getType(), pageSettings.getBaseUrl());

				Boolean flagAsExpired = false;

				if(!resultData.isEmpty()) {

					// Attempt to source the official quote URL
					String quoteUrl = this.getResultProperty(resultData, "quoteUrl");
					String validateDate = this.getResultProperty(resultData, "validateDate/normal");

					if(quoteUrl != null && validateDate != null && this.validateDateNotExpired(validateDate)) {
						// Set to the quoteUrl recorded in the result set
						redirectionUrl.append(quoteUrl);
					} else {
						// Otherwise use url for loading the first page of the journey
						emailUrlService.updateWithLoadQuoteUrl(redirectionUrl, emailData);

						// Add expired flag for front-end to handle
						flagAsExpired = true;
					}

				} else {
					// Otherwise use url for loading the first page of the journey
					emailUrlService.updateWithLoadQuoteUrl(redirectionUrl, emailData);

					if(emailData.getEmailType() == EmailMode.PROMOTION) {
						// Add expired flag by default for promotion emails
						flagAsExpired = true;
					}
				}

				if(flagAsExpired == true) {
					emailUrlService.updateAsExpired(redirectionUrl);
				}

			} else {
				// Otherwise use the Exit URL (usually pointing to brochure site)
				redirectionUrl.append(pageSettings.getSetting("exitUrl"));
			}
		} catch (DaoException | EnvironmentException | VerticalException | ConfigSettingException e) {
			logger.error(e);
		}

		return redirectionUrl.toString();
	}

	/**
	 * getResultProperty searches the result properties list and return the value of the nominated property
	 *
	 * @param properties
	 * @param property
	 * @return
	 */
	private String getResultProperty(ArrayList<ResultProperty> properties, String property) {
		String propertyVal = null;
		for (ResultProperty prop : properties) {
			if(prop.getProperty().contentEquals(property)) {
				propertyVal = prop.getValue();
			}
		}

		return propertyVal;
	}

	/**
	 * validateDateNotExpired confirms the current date is not before the validateDate
	 *
	 * @param validateDate
	 * @return
	 * @throws ParseException
	 */
	private Boolean validateDateNotExpired(String validateDate)  {
		boolean expired = true;
		Date today = new Date(); // your date
		Calendar todayCal = Calendar.getInstance();
		todayCal.setTime(today);
		todayCal = new GregorianCalendar(todayCal.get(Calendar.YEAR), todayCal.get(Calendar.MONTH), todayCal.get(Calendar.DAY_OF_MONTH));

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date expires;
		try {
			expires = sdf.parse(validateDate);
			Calendar expiresCal = Calendar.getInstance();
			expiresCal.setTime(expires);
			expired = expiresCal.compareTo(todayCal) >= 0;
		} catch (ParseException e) {
			logger.error(e);
		}
		return expired;
	}
}
