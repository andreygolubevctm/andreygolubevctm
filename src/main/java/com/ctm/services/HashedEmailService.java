package com.ctm.services;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;

public class HashedEmailService {

	private final EmailMasterDao emailDao;

	/**
	 * Used by JSP
	 */
	public HashedEmailService() {
		emailDao = new EmailMasterDao();
	}

	public HashedEmailService(EmailMasterDao emailDao) {
		this.emailDao = emailDao;
	}

	/**
	 * Get email details from the database and check if valid
	 *
	 * @param hashedEmail required
	 * @param email optional defaults to just checking if hashedEmail is in database
	 * @param brandId
	 * @return mapping including boolean is the details are valid
	 * @throws DaoException 
	 */
	public EmailMaster getEmailDetails(String hashedEmail, String emailAddress, int brandId) throws DaoException {
		EmailMaster emailMaster;
		if ( hashedEmail == null || hashedEmail.isEmpty()) {
			emailMaster = handleNoHashedEmail(emailAddress, brandId);
		} else if(emailAddress != null && !emailAddress.isEmpty()){
			emailMaster = handleWithEmailAddress(hashedEmail, emailAddress, brandId);
		} else {
			emailMaster = handleWithOnlyHashedEmail(hashedEmail, brandId);
		} 
		return emailMaster;
	}

	private EmailMaster handleNoHashedEmail(String emailAddress, int brandId) {
		EmailMaster emailMaster = new EmailMaster();
		emailMaster.setEmailAddress(emailAddress);
		FatalErrorService.logFatalError(brandId, "" , "", false, emailAddress, "hashedEmail is empty", null);
		emailMaster.setValid(false);
		return emailMaster;
	}

	private EmailMaster handleWithEmailAddress(String hashedEmail,
			String email, int brandId)
			throws DaoException {
		EmailMaster emailMaster = emailDao.getEmailMaster(email, brandId);
		emailMaster.setValid(hashedEmail.equals(emailMaster.getHashedEmail()));
		return emailMaster;
	}

	private EmailMaster handleWithOnlyHashedEmail(String hashedEmail, int brandId)
			throws DaoException {
		EmailMaster emailMaster = emailDao.getEmailMasterFromHashedEmail(hashedEmail, brandId);
		emailMaster.setValid(emailMaster.getEmailId() > 0);
		return emailMaster;
	}

}
