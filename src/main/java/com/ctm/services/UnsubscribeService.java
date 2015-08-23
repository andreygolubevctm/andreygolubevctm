package com.ctm.services;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Unsubscribe;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.email.EmailUrlService;

public class UnsubscribeService {
	
	private static Logger logger = Logger.getLogger(UnsubscribeService.class.getName());
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
	 * @param request
	 * @return
	 */
	public Unsubscribe getUnsubscribeDetails(String vertical, int  brandId,
			String hashedEmail, String email, boolean isDisc, PageSettings pageSettings, HttpServletRequest request) {
		email = EmailUrlService.decodeEmailAddress(email);
		Unsubscribe unsubscribe = new Unsubscribe();
		unsubscribe.setVertical(vertical);
		if (!isDisc) {
			if(brandId == 0) {
				brandId = pageSettings.getBrandId();
			}

			try {
				unsubscribe.setEmailDetails(hashedEmailService.getEmailDetails(hashedEmail, email, brandId));
			} catch (DaoException e) {
				logger.error(e);
				FatalErrorService.logFatalError(e, brandId, "failed to unsubscribe" , "", true);
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
