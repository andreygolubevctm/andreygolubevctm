package com.ctm.services;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ctm.dao.TransactionDetailsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.TransactionDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.email.EmailUrlService;

public class RemoteLoadQuoteService {

	private final TransactionDetailsDao transactionDetailsDao;
	private final TransactionAccessService transactionAccessService;

	private static Logger logger = Logger.getLogger(RemoteLoadQuoteService.class.getName());

	// do not remove as used by the jsp
	public RemoteLoadQuoteService(){
		transactionDetailsDao = new TransactionDetailsDao();
		transactionAccessService = new TransactionAccessService();
	}

	public RemoteLoadQuoteService(TransactionAccessService transactionAccessService, TransactionDetailsDao transactionDetailsDao){
		this.transactionAccessService = transactionAccessService;
		this.transactionDetailsDao = transactionDetailsDao;
	}

	public List<TransactionDetail> getTransactionDetails(String hashedEmail, String vertical, String type, String emailAddress, long transactionId, int brandId) throws DaoException{
		emailAddress = EmailUrlService.decodeEmailAddress(emailAddress);
		logger.info("Checking details vertical:" + vertical + " type:" + type + " emailAddress:" + emailAddress + " transactionId:" + transactionId + " brandId:" + brandId);
		logger.debug("hashedEmail: " + hashedEmail);
		EmailMode emailMode = EmailMode.findByCode(type);
		VerticalType verticalType = VerticalType.findByCode(vertical);
		IncomingEmail emailData = new IncomingEmail();
		emailData.setEmailAddress(emailAddress);
		emailData.setEmailHash(hashedEmail);
		emailData.setTransactionId(transactionId);
		emailData.setEmailType(emailMode);
		if( transactionAccessService.hasAccessToTransaction(emailData,brandId, verticalType)) {
			return transactionDetailsDao.getTransactionDetails(transactionId);
		}
		return new ArrayList<>();
	}

}
