package com.ctm.web.core.services;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.model.settings.VerticalSettings;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.utils.common.utils.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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
		List<TransactionDetail> transactionDetails = new ArrayList<>();
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
			transactionDetails = transactionDetailsDao.getTransactionDetails(transactionId);
			// Get DOBs and generate ages for new xpath
			if(VerticalType.TRAVEL == verticalType){
				StringBuffer ages = new StringBuffer();

				 /*transactionDetails.stream().forEach(transaction ->{
					if(transaction.getXPath().equalsIgnoreCase("travel/travellers/traveller1DOB")){
						if(StringUtils.isNotEmpty(ages)) {
							ages.append(",");
						}
						ages.append(DateUtils.getAgeFromDob(DateUtils.parseStringToLocalDate(transaction.getTextValue())));
					}
					if(transaction.getXPath().equalsIgnoreCase("travel/travellers/traveller2DOB")){
						if(StringUtils.isNotEmpty(ages)) {
							ages.append(",");
						}
						ages.append(DateUtils.getAgeFromDob(DateUtils.parseStringToLocalDate(transaction.getTextValue())));
					}
					});
					if(StringUtils.isNotEmpty(ages)){
						TransactionDetail newTransactionDetail = new TransactionDetail("travel/travellers/travellersAge" ,ages.toString());
						transactionDetails.add(newTransactionDetail);
					}
*/
				TransactionDetail newTransactionDetail = transactionDetails.stream()
							.filter(td -> Arrays.asList("travel/travellers/traveller1DOB","travel/travellers/traveller2DOB").contains(td.getXPath()))
							.filter(td -> StringUtils.isNotBlank(td.getTextValue()))
							.map(td -> DateUtils.parseStringToLocalDate(td.getTextValue()))
							.map(td -> DateUtils.getAgeFromDob(td))
							.map(String::valueOf)
							.collect(Collectors.collectingAndThen(Collectors.joining(","),
									ages1 -> new TransactionDetail("travel/travellers/travellersAge",ages1)));
				if(StringUtils.isNotBlank(newTransactionDetail.getTextValue())){
					transactionDetails.add(newTransactionDetail);
				}


			}
		}
		return transactionDetails;
	}


	public String getActionQuoteUrl(String vertical , String action , Long transactionId , String jParam, String trackingParams){
		return VerticalSettings.getHomePageJsp(vertical) + "?action=" + action + "&amp;transactionId=" + transactionId + jParam + trackingParams;
	}

	public String getStartAgainQuoteUrl(String vertical , Long transactionId , String jParam, String trackingParams){
		return getActionQuoteUrl( vertical , "start-again" ,  transactionId ,  jParam, trackingParams);
	}

	public String getLatestQuoteUrl(String vertical , Long transactionId , String jParam,  String trackingParams){
		return getActionQuoteUrl( vertical , "latest" ,  transactionId ,  jParam, trackingParams);
	}


}
