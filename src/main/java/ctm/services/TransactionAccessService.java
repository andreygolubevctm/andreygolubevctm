package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.dao.transaction.TransactionDao;
import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;
import com.ctm.model.Transaction;
import com.ctm.model.TransactionDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.Vertical.VerticalType;

public class TransactionAccessService {

	private static Logger logger = Logger.getLogger(TransactionAccessService.class.getName());

	public static final String HEALTH_BEST_PRICE_EMAIL_XPATH = "health/contactDetails/email";

	private final HashedEmailService hashedEmailService;
	private final TransactionDetailsDao transactionDetailsDao;
	private final TransactionDao transactionDao;

	public TransactionAccessService(){
		hashedEmailService = new HashedEmailService();
		transactionDetailsDao = new TransactionDetailsDao();
		this.transactionDao = new TransactionDao();
	}

	public TransactionAccessService(HashedEmailService hashedEmailService, TransactionDetailsDao transactionDetailsDao, TransactionDao transactionDao){
		this.hashedEmailService = hashedEmailService;
		this.transactionDetailsDao = transactionDetailsDao;
		this.transactionDao = transactionDao;
	}

	public boolean hasAccessToTransaction(IncomingEmail emailData, int brandId, VerticalType verticalType) {
		boolean valid = false;
		try {
			EmailMaster emailRequest = emailData.getEmailMaster();
			EmailMaster result = hashedEmailService.getEmailDetails(emailRequest.getHashedEmail(), emailRequest.getEmailAddress(), brandId);
			if(result != null && result.isValid()){
					if(verticalType == VerticalType.HEALTH) {
						valid =  healthHasAccessToTransaction(result, emailData.getTransactionId(),  emailData.getEmailType());
					} else {
						valid = hasAccessTransactionHeader(result,
								emailData.getTransactionId());
					}
					emailData.setEmailAddress(result.getEmailAddress());
			}
		} catch (DaoException e) {
			logger.error(e);
		}
		return valid;
	}

	private boolean healthHasAccessToTransaction(EmailMaster emailDetails, long transactionId, EmailMode emailMode) throws DaoException {
		boolean valid = false;
		if(emailMode == EmailMode.BEST_PRICE){
			TransactionDetail transactionDetail = transactionDetailsDao.getTransactionDetailByXpath(transactionId, HEALTH_BEST_PRICE_EMAIL_XPATH);
			valid = transactionDetail != null && transactionDetail.getTextValue().equalsIgnoreCase(emailDetails.getEmailAddress());
		} else {
			valid = hasAccessTransactionHeader(emailDetails,
					transactionId);
		}
		return valid;
	}

	private boolean hasAccessTransactionHeader(EmailMaster emailDetails,
			long transactionId) throws DaoException {
		boolean valid;
		Transaction transaction = new Transaction();
		transaction.setTransactionId(transactionId);
		Transaction transactionFromDB = transactionDao.getCoreInformation(transaction);
		valid = transactionFromDB != null && emailDetails.getEmailAddress().equals(transactionFromDB.getEmailAddress());
		return valid;
	}

}