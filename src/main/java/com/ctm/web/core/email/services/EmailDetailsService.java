package com.ctm.web.core.email.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.StampingService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.validation.EmailValidation;
import com.ctm.web.core.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import java.security.GeneralSecurityException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class EmailDetailsService {

	private static final String SALT =  "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1yt N|E2qg";

	private final Data data;
	private final EmailDetailsMappings emailDetailMappings;
	private EmailMasterDao emailMasterDao;
	private final TransactionDao transactionDao;
	private String brandCode;
	private StampingService stampingService;

	private String vertical;

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailDetailsService.class);

	/**
	 * TODO used by JSP remove when jsp has been refactored
	 */
	@Deprecated
	public EmailDetailsService() {
		data = null;
		emailDetailMappings = null;
		transactionDao = null;
	}

	/**
	 * TODO used by JSP remove when jsp has been refactored
	 */
	public void init(int brandId, String brandCode, String vertical) {
		this.emailMasterDao = new EmailMasterDao(brandId, brandCode, vertical);
		this.brandCode = brandCode;
	}

	@Autowired
	public EmailDetailsService(EmailMasterDao emailMasterDao, TransactionDao transactionDao, Data data ,
			String brandCode, EmailDetailsMappings emailDetailMappings, StampingDao stampingDao, String vertical) {
		this.emailMasterDao = emailMasterDao;
		this.transactionDao = transactionDao;
		this.brandCode = brandCode;
		this.data = data;
		this.emailDetailMappings = emailDetailMappings;
		this.stampingService = new StampingService(stampingDao);
		this.vertical = vertical;
	}

	public EmailMaster handleReadAndWriteEmailDetails(long transactionId, EmailMaster emailDetailsRequest, String operator, String ipAddress)
			throws EmailDetailsException {
		EmailMaster emailDetails = emailDetailsRequest.clone();
		EmailMaster emailDetailsDB;
		try {
			emailDetailsDB = emailMasterDao.getEmailDetails(emailDetailsRequest.getEmailAddress());
			if(emailDetailsDB == null) {
				LOGGER.debug("email not in database adding now {}, {}", kv("emailAddress", emailDetailsRequest.getEmailAddress()),
					kv("transactionId", transactionId), kv("operator", operator), kv("ipAddress", ipAddress));
				emailDetailsDB = writeNewEmailDetails(transactionId , emailDetailsRequest);
				// new email address write if opted in database
				stampingService.writeOptInMarketing(emailDetails, operator, emailDetailsRequest.getOptedInMarketing(vertical), ipAddress);
			} else {
				// only write if not opted in database
				if(!emailDetailsDB.getOptedInMarketing(vertical)){
					stampingService.writeOptInMarketing(emailDetails, operator, emailDetailsRequest.getOptedInMarketing(vertical), ipAddress);
				}
			}
			Transaction transaction = new Transaction();
			transaction.setTransactionId(transactionId);
			transaction.setEmailAddress(emailDetailsRequest.getEmailAddress());
			transactionDao.writeEmailAddress(transaction);
		} catch (DaoException e) {
			throw new EmailDetailsException("failed to write email details to database",e);
		}
		emailDetails.setFirstName(getFirstName(emailDetailsRequest, emailDetailsDB));
		emailDetails.setLastName(getLastName(emailDetailsRequest, emailDetailsDB));
		emailDetails.setHashedEmail(emailDetailsDB.getHashedEmail());
		emailDetails.setOptedInMarketing(getOptedIn(emailDetailsRequest, emailDetailsDB) , vertical);
		emailDetails.setEmailId(emailDetailsDB.getEmailId());
		return emailDetails;
	}

	/**
	 * returns hashed email for given email address from db.
	 *
	 * @param emailAddress
	 * @return hashed email OR empty string if no hashed email found in db.
	 * @throws DaoException when reading `email_master` record.
	 */
	public String getHashedEmail(String emailAddress) throws DaoException {
		final EmailMaster emailMasterFromDb = emailMasterDao.getEmailDetails(emailAddress);

		if (emailMasterFromDb == null) {
			LOGGER.error("Returning empty hashed email. Unable to find email master record for email: {}", emailAddress);
			return StringUtils.EMPTY;
		}

		return emailMasterFromDb.getHashedEmail();
	}

	/**
	 * TODO: this is used my write_email.tag refactor write_email and remove this method
	 * @param emailAddress
	 * @param emailPassword
	 * @param source
	 * @param firstName
	 * @param lastName
	 * @param transactionId
	 * @return
	 * @throws EmailDetailsException
	 */
	public int handleWriteEmailDetailsFromJsp(String emailAddress, String emailPassword , String source, String firstName ,
											   String lastName, String transactionId) throws EmailDetailsException {
		EmailMaster emailMaster = new EmailMaster();
		if(EmailValidation.validate(emailAddress)){
			emailMaster.setEmailAddress(emailAddress);
			emailMaster.setPassword(emailPassword);
			emailMaster.setSource(source);
			emailMaster.setFirstName(firstName);
			emailMaster.setLastName(lastName);
			try {
				emailMaster.setHashedEmail(StringEncryption.hash(emailAddress + SALT + brandCode.toUpperCase()));
			} catch (GeneralSecurityException e) {
				LOGGER.error("Failed to hash email {}, {}, {}", kv("emailAddress", emailAddress), kv("brandCode", brandCode), kv("transactionId", transactionId));
				throw new EmailDetailsException("failed to hash email", e);
			}
			long transId = 0L;
			try {
				transId =  Long.parseLong(transactionId);
			} catch (NumberFormatException e) {
				//Session probably died recoverable
				LOGGER.warn("Session likely failed {}", kv("transactionId", transactionId), e);
			}
			emailMaster = writeNewEmailDetails(transId , emailMaster);
		}
		return emailMaster.getEmailId();
	}

	private EmailMaster writeNewEmailDetails(
			long transactionId, EmailMaster emailDetailsRequest) throws EmailDetailsException {

		EmailMaster emailDetails = emailDetailsRequest.clone();
		emailDetails.setFirstName(getFirstName(emailDetailsRequest));
		emailDetails.setLastName(getLastName(emailDetailsRequest));

		emailDetails.setTransactionId(transactionId);
		emailDetails.setEmailAddress(emailDetailsRequest.getEmailAddress().toLowerCase());
		if(emailDetails.getEmailAddress().length() > 256){
			emailDetails.setEmailAddress(emailDetails.getEmailAddress().substring(0, 256));
		}
		try {
			emailDetails.setHashedEmail(StringEncryption.hash(emailDetails.getEmailAddress() + SALT + brandCode.toUpperCase()));
			return emailMasterDao.writeEmailDetails(emailDetails);
		} catch (GeneralSecurityException | DaoException e) {
			throw new EmailDetailsException("failed to write to email details", e);
		}
	}

	private String getLastName(EmailMaster emailDetailsRequest,
			EmailMaster emailDetailsDB) {

		String dataObjectLastName = getLastName(emailDetailsRequest);
		String dataBaseLastName = emailDetailsDB != null ?emailDetailsDB.getLastName() : "";

		return dataObjectLastName != null && !dataObjectLastName.isEmpty()? dataObjectLastName : dataBaseLastName;
	}

	private String getLastName(EmailMaster emailDetailsRequest) {
		boolean useRequest = (emailDetailsRequest.getLastName() != null && !emailDetailsRequest.getLastName().isEmpty()) || emailDetailMappings == null;
		return useRequest ? emailDetailsRequest.getLastName() : emailDetailMappings.getLastName(this.data);
	}

	private String getFirstName(EmailMaster emailDetailsRequest,
			EmailMaster emailDetailsDB) {
		String dataObjectFirstName = getFirstName(emailDetailsRequest);
		String dataBaseFirstName = emailDetailsDB != null ? emailDetailsDB.getFirstName() : "";
		return dataObjectFirstName != null && !dataObjectFirstName.isEmpty()? dataObjectFirstName : dataBaseFirstName;

	}

	private String getFirstName(EmailMaster emailDetailsRequest) {
		boolean useRequest = (emailDetailsRequest.getFirstName() != null && !emailDetailsRequest.getFirstName().isEmpty()) || emailDetailMappings == null;
		return useRequest ? emailDetailsRequest.getFirstName() : emailDetailMappings.getFirstName(this.data);

	}

	private boolean getOptedIn(EmailMaster emailDetailsRequest,
			EmailMaster emailDetailsDB) {
		return emailDetailsRequest.getOptedInMarketing(vertical) || emailDetailsDB.getOptedInMarketing(vertical);

	}
}
