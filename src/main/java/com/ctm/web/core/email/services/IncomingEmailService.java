package com.ctm.web.core.email.services;

import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.TransactionProperties;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.results.dao.ResultsDao;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.services.TransactionAccessService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class IncomingEmailService {

	private static final Logger LOGGER = LoggerFactory.getLogger(IncomingEmailService.class);

	/**
	 * Create a URL for viewing a confirmation that is brand and vertical aware.
	 *
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

				EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(pageSettings);
				EmailUrlService emailUrlService = new EmailUrlService(pageSettings.getVertical().getType(), pageSettings.getBaseUrl(), emailTokenService);

				Boolean flagAsExpired = false;

				if(!resultData.isEmpty()) {

					// Attempt to source the official quote URL
					String quoteUrl = this.getResultProperty(resultData, "quoteUrl");
					String validateDate = this.getResultProperty(resultData, "validateDate/normal");

					// The following is a fix for CRM-492.
					// eDM for CRM-467 has quoteURL with quotes that haven't expired and have no productId in the URL
					if(emailData.getProductId() == null || emailData.getProductId().isEmpty()) {
						// Redirect to the first page of the journey
						emailUrlService.updateWithLoadQuoteUrl(redirectionUrl, emailData);

						// Add expired flag for front-end to handle
						if(emailData.getEmailType() == EmailMode.PROMOTION) {
							// Add expired flag by default for promotion emails
							flagAsExpired = true;
						}
					} else if(quoteUrl != null && validateDate != null && this.validateDateNotExpired(validateDate)) {
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
			LOGGER.error("Failed to get redirect url {}", kv("incomingEmail", emailData), e);
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
			LOGGER.error("Unable to parse incoming email date {}", kv("validateDate", validateDate), e);
		}
		return expired;
	}
}
