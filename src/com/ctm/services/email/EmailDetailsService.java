package com.ctm.services.email;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.StampingDao;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailDetails;
import com.ctm.model.Transaction;
import com.ctm.security.StringEncryption;
import com.ctm.services.StampingService;
import com.ctm.services.email.mapping.EmailDetailsMappings;
import com.disc_au.web.go.Data;

public class EmailDetailsService {

	private static final String SALT =  "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1yt N|E2qg";

	private final Data data;
	private final EmailDetailsMappings emailDetailMappings;
	private final EmailMasterDao emailMasterDao;
	private final TransactionDao transactionDao;
	private final String brandCode;
	private StampingService stampingService;

	private String vertical;

	private static Logger logger = Logger.getLogger(EmailDetailsService.class.getName());

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

	public EmailDetailsService(EmailMasterDao emailMasterDao, TransactionDao transactionDao ,
			String brandCode) {
		this.emailMasterDao = emailMasterDao;
		this.transactionDao = transactionDao;
		this.brandCode = brandCode;
		this.data = null;
		this.emailDetailMappings = null;
	}

	public EmailDetails handleReadAndWriteEmailDetails(long transactionId, EmailDetails emailDetailsRequest, String operator, String ipAddress)
			throws EmailDetailsException {
		EmailDetails emailDetails = emailDetailsRequest.copy();
		EmailDetails emailDetailsDB;
		try {
			emailDetailsDB = emailMasterDao.getEmailDetails(emailDetailsRequest.getEmailAddress());
			if(emailDetailsDB == null) {
				logger.info(transactionId + ": " + emailDetailsRequest.getEmailAddress() + " email not in database adding now");
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
			throw new EmailDetailsException("failed to write to database",e);
		}
		emailDetails.setFirstName(getFirstName(emailDetailsRequest, emailDetailsDB));
		emailDetails.setLastName(getLastName(emailDetailsRequest, emailDetailsDB));
		emailDetails.setHashedEmail(emailDetailsDB.getHashedEmail());
		emailDetails.setOptedInMarketing(getOptedIn(emailDetailsRequest, emailDetailsDB) , vertical);

		return emailDetails;
	}

	private EmailDetails writeNewEmailDetails(
			long transactionId, EmailDetails emailDetailsRequest) throws EmailDetailsException {

		EmailDetails emailDetails = emailDetailsRequest.copy();
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
		} catch (InvalidKeyException | NoSuchAlgorithmException | DaoException e) {
			throw new EmailDetailsException("failed to write to email details", e);
		}
	}

	private String getLastName(EmailDetails emailDetailsRequest,
			EmailDetails emailDetailsDB) {

		String dataObjectLastName = getLastName(emailDetailsRequest);
		String dataBaseLastName = emailDetailsDB != null ?emailDetailsDB.getLastName() : "";

		return dataObjectLastName != null && !dataObjectLastName.isEmpty()? dataObjectLastName : dataBaseLastName;
	}

	private String getLastName(EmailDetails emailDetailsRequest) {
		boolean useRequest = (emailDetailsRequest.getLastName() != null && !emailDetailsRequest.getLastName().isEmpty()) || emailDetailMappings == null;
		return useRequest ? emailDetailsRequest.getLastName() : emailDetailMappings.getLastName(this.data);
	}

	private String getFirstName(EmailDetails emailDetailsRequest,
			EmailDetails emailDetailsDB) {
		String dataObjectFirstName = getFirstName(emailDetailsRequest);
		String dataBaseFirstName = emailDetailsDB != null ? emailDetailsDB.getFirstName() : "";
		return dataObjectFirstName != null && !dataObjectFirstName.isEmpty()? dataObjectFirstName : dataBaseFirstName;

	}

	private String getFirstName(EmailDetails emailDetailsRequest) {
		boolean useRequest = (emailDetailsRequest.getFirstName() != null && !emailDetailsRequest.getFirstName().isEmpty()) || emailDetailMappings == null;
		return useRequest ? emailDetailsRequest.getFirstName() : emailDetailMappings.getFirstName(this.data);

	}

	private boolean getOptedIn(EmailDetails emailDetailsRequest,
			EmailDetails emailDetailsDB) {
		return emailDetailsRequest.getOptedInMarketing(vertical) || emailDetailsDB.getOptedInMarketing(vertical);

	}
}
