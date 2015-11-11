package com.ctm.web.core.services;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.EmailMaster;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Unsubscribe;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.email.services.EmailUrlService;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class UnsubscribeService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(UnsubscribeService.class);
	private HashedEmailService hashedEmailService;
	private EmailMasterDao emailDao;

	/**
	 * Used by JSP
	 */
	public UnsubscribeService() {
		this.hashedEmailService = new HashedEmailService();
	}

	/**
	 * Constructor for unit tests/Java usage
	 * @param emailDao
	 */
	public UnsubscribeService(EmailMasterDao emailDao) {
		this.hashedEmailService  = new HashedEmailService(emailDao);
		this.emailDao = emailDao;
	}

	/**
	 * Retrieve the necessary customer details
	 * @param vertical
	 * @param hashedEmail
	 * @param email
	 * @param isDisc
	 * @param pageSettings
	 * @return
	 */
	public Unsubscribe getUnsubscribeDetails(String vertical, int  brandId,
			String hashedEmail, String email, boolean isDisc, PageSettings pageSettings, String token) throws ConfigSettingException {
		Unsubscribe unsubscribe = new Unsubscribe();

		if(token != null && !token.isEmpty()) {
			EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(pageSettings);
			EmailMaster emailMaster = emailTokenService.getEmailAddressDetails(token);

			if(emailMaster != null) {
				unsubscribe.setVertical(emailMaster.getVertical());
				unsubscribe.setEmailDetails(emailMaster);
			} else {
				LOGGER.info("Unsubscribe token has expired {}", kv("parameters", emailTokenService.decryptToken(token)));
			}

		} else {
			email = EmailUrlService.decodeEmailAddress(email);

			unsubscribe.setVertical(vertical);
			if (!isDisc) {
				if(brandId == 0) {
					brandId = pageSettings.getBrandId();
				}

				try {
					unsubscribe.setEmailDetails(hashedEmailService.getEmailDetails(hashedEmail, email, brandId));
				} catch (DaoException e) {
					LOGGER.error("Error unsubscribing {},{},{}", kv("hashedEmail", hashedEmail), kv("email", email), kv("brandId", brandId));
					FatalErrorService.logFatalError(e, brandId, "failed to unsubscribe", "", true);
				}
			}
		}
		return unsubscribe;
	}

	/**
	 *
	 * @param pageSettings
	 * @param unsubscribe
	 * @throws DaoException
	 */
	public void unsubscribe(PageSettings pageSettings, Unsubscribe unsubscribe) throws DaoException {
		int brandId = pageSettings.getBrandId();
		if(emailDao == null){
			emailDao = new EmailMasterDao(brandId, pageSettings.getBrandCode() , unsubscribe.getVertical());
		}
		if(unsubscribe.getVertical() != null && !unsubscribe.getVertical().isEmpty()){
			unsubscribe.getEmailDetails().setOptedInMarketing(false, unsubscribe.getVertical().toLowerCase());
			emailDao.writeToEmailProperties(unsubscribe.getEmailDetails());
		} else{
			emailDao.writeToEmailPropertiesAllVerticals(unsubscribe.getEmailDetails());
		}
	}


}
