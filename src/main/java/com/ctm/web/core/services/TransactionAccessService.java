package com.ctm.web.core.services;

import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class TransactionAccessService {

	private static final Logger LOGGER = LoggerFactory.getLogger(TransactionAccessService.class);

	public static final String HEALTH_BEST_PRICE_EMAIL_XPATH = "health/contactDetails/email";
	public static final String HEALTH_BROCHURE_EMAIL_HISTORY_XPATH = "health/brochureEmailHistory";

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
			} else {
				LOGGER.debug("HashedEamilService could not find a match {}, {},{},{}", kv("result", result), kv("emailData", emailData), kv("verticalType", verticalType), kv("brandId", brandId));
			}
		} catch (DaoException e) {
			LOGGER.error("Error checking transaction access {},{},{}", kv("emailData", emailData), kv("verticalType", verticalType), kv("brandId", brandId), e);
		}
		return valid;
	}

	private boolean healthHasAccessToTransaction(EmailMaster emailDetails, long transactionId, EmailMode emailMode) throws DaoException {
		boolean valid = false;
		if(emailMode == EmailMode.BEST_PRICE){
			TransactionDetail transactionDetail = transactionDetailsDao.getTransactionDetailByXpath(transactionId, HEALTH_BEST_PRICE_EMAIL_XPATH);
			valid = transactionDetail != null && transactionDetail.getTextValue().equalsIgnoreCase(emailDetails.getEmailAddress());
		} else if(emailMode == EmailMode.PRODUCT_BROCHURES) {
			TransactionDetail transactionDetail = transactionDetailsDao.getTransactionDetailByXpath(transactionId,
					HEALTH_BROCHURE_EMAIL_HISTORY_XPATH);
			valid = transactionDetail != null && transactionDetail.getTextValue().contains(emailDetails.getEmailAddress());
			if(!valid) {
				// backup checks for existing emails before the email history record existed
				transactionDetail = transactionDetailsDao.getTransactionDetailByXpath(transactionId, HEALTH_BEST_PRICE_EMAIL_XPATH);
				valid = transactionDetail != null && transactionDetail.getTextValue().equalsIgnoreCase(emailDetails.getEmailAddress());
				if(!valid) {
					valid = hasAccessTransactionHeader(emailDetails, transactionId);
				}
			}
		} else {
			valid = hasAccessTransactionHeader(emailDetails, transactionId);
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

	public void addTransactionDetailsWithDuplicateKeyUpdate(long transactionId, int sequenceNo, String xpath, String textValue) throws DaoException {
		final TransactionDetail transactionDetail = new TransactionDetail();
		transactionDetail.setSequenceNo(sequenceNo);
		transactionDetail.setXPath(xpath);
		transactionDetail.setTextValue(textValue);
		transactionDetailsDao.addTransactionDetailsWithDuplicateKeyUpdate(transactionId, transactionDetail);
	}

	public void addTransactionDetails(long transactionId, int sequenceNo, String xpath, String textValue) throws DaoException {
		final TransactionDetail transactionDetail = new TransactionDetail();
		transactionDetail.setSequenceNo(sequenceNo);
		transactionDetail.setXPath(xpath);
		transactionDetail.setTextValue(textValue);
		transactionDetailsDao.addTransactionDetails(transactionId, transactionDetail);
	}

}