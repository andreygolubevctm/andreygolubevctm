package com.ctm.web.core.services;

import java.util.ArrayList;
import java.util.List;

import com.ctm.web.core.model.settings.VerticalSettings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.email.services.EmailUrlService;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class RemoteLoadQuoteService {

	private final TransactionDetailsDao transactionDetailsDao;
	private final TransactionAccessService transactionAccessService;

	private static final Logger LOGGER = LoggerFactory.getLogger(RemoteLoadQuoteService.class);

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
		LOGGER.debug("Checking details vertical {},{},{},{},{}", kv("vertical", vertical), kv("type", type), kv("emailAddress", emailAddress),
			kv("transactionId", transactionId), kv("brandId", brandId));
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

	public String getActionQuoteUrl(String vertical , String action , Long transactionId , String jParam){
		return VerticalSettings.getHomePageJsp(vertical) + "?action=" + action + "&amp;transactionId=" + transactionId + jParam;
	}

	public String getStartAgainQuoteUrl(String vertical , Long transactionId , String jParam){
		return getActionQuoteUrl( vertical , "start-again" ,  transactionId ,  jParam);
	}

	public String getLatestQuoteUrl(String vertical , Long transactionId , String jParam){
		return getActionQuoteUrl( vertical , "latest" ,  transactionId ,  jParam);
	}


}
