package com.ctm.services.email;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.model.EmailDetails;
import com.ctm.model.Transaction;
import com.ctm.security.StringEncryption;
import com.ctm.services.email.mapping.EmailDetailsMappings;
import com.disc_au.web.go.Data;

public class EmailDetailsService {

	private static final String SALT =  "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1yt N|E2qg";

	private EmailMasterDao emailMasterDao;
	private TransactionDao transactionDao;

	private Data data;

	private String brandCode;

	private EmailDetailsMappings emailDetailMappings;

	private static Logger logger = Logger.getLogger(EmailDetailsService.class.getName());

	public EmailDetailsService(EmailMasterDao emailMasterDao, TransactionDao transactionDao, Data data ,
			String brandCode, EmailDetailsMappings emailDetailMappings) {
		this.emailDetailMappings = emailDetailMappings;
		this.data = data;
		this.emailMasterDao = emailMasterDao;
		this.transactionDao = transactionDao;
		this.brandCode = brandCode;
	}


	public EmailDetailsService(EmailMasterDao emailMasterDao, TransactionDao transactionDao ,
			String brandCode) {
		this.emailMasterDao = emailMasterDao;
		this.transactionDao = transactionDao;
		this.brandCode = brandCode;
	}

	public EmailDetails handleReadAndWriteEmailDetails(
			HttpServletRequest request, String emailAddress, long transactionId, String source)
			throws EmailDetailsException {
		EmailDetails emailDetails;
		try {
			emailDetails = emailMasterDao.getEmailDetails(emailAddress);
			if(emailDetails == null) {
				logger.info(transactionId + ": " + emailAddress + " email not in database adding now");
				emailDetails = writeNewEmailDetails(request, transactionId, data , emailAddress, source);
			} else if(data != null) {
				populateName(emailDetails, data);
			}
			Transaction transaction = new Transaction();
			transaction.setTransactionId(transactionId);
			transaction.setEmailAddress(emailAddress);
			transactionDao.writeEmailAddress(transaction);
		} catch (DaoException e) {
			throw new EmailDetailsException("failed to write to database",e);
		}
		return emailDetails;
	}

	private EmailDetails writeNewEmailDetails(HttpServletRequest request,
			long transactionId, Data data, String emailAddress, String source) throws EmailDetailsException {
		EmailDetails emailDetails = new EmailDetails();

		populateName(emailDetails, data);
		emailDetails.setTransactionId(transactionId);
		emailAddress = emailAddress.toLowerCase();
		if(emailAddress.length() > 256){
			emailAddress = emailAddress.toLowerCase().substring(0, 256);
		}
		try {
			emailDetails.setHashedEmail(StringEncryption.hash(emailAddress + SALT + brandCode.toUpperCase()));
			emailDetails.setEmailAddress(emailAddress);
			return emailMasterDao.writeEmailDetails(emailDetails, source);
		} catch (InvalidKeyException | NoSuchAlgorithmException | DaoException e) {
			throw new EmailDetailsException("failed to write to email details", e);
		}
	}

	private void populateName(EmailDetails emailDetails, Data data) {
		String firstName = emailDetailMappings.getFirstName(data);
		String lastName = emailDetailMappings.getFirstName(data);
		if(!firstName.isEmpty()){
			emailDetails.setFirstName(firstName);
		}
		if(!lastName.isEmpty()){
			emailDetails.setLastName(lastName);
		}
	}

}
