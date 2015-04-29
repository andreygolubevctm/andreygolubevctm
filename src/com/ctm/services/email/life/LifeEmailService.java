package com.ctm.services.email.life;

import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;

import com.ctm.dao.RankingDetailsDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.dao.life.OccupationsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.EmailMaster;
import com.ctm.model.RankingDetail;
import com.ctm.model.TransactionDetail;
import com.ctm.model.email.EmailMode;
import com.ctm.model.email.LifeBestPriceEmailModel;
import com.ctm.model.formatter.email.life.LifeBestPriceExactTargetFormatter;
import com.ctm.model.life.Occupation;
import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.email.BestPriceEmailHandler;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.EmailUrlService;
import com.ctm.services.email.ExactTargetEmailSender;
import com.disc_au.web.go.Data;

public class LifeEmailService extends EmailServiceHandler implements BestPriceEmailHandler {
	
	private static final String VERTICAL = VerticalType.LIFE.getCode();
	
	private static final Logger logger = Logger.getLogger(LifeEmailService.class.getName());
	
	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private String optInMailingName;
	public LifeEmailService(PageSettings pageSettings, EmailMode emailMode, EmailDetailsService emailDetailsService, EmailUrlService urlService) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
	}

	@Override
	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(BestPriceEmailHandler.MAILING_NAME_KEY);
		optInMailingName = getPageSetting(BestPriceEmailHandler.OPT_IN_MAILING_NAME);
		ExactTargetEmailSender<LifeBestPriceEmailModel> emailSender = new ExactTargetEmailSender<LifeBestPriceEmailModel>(pageSettings, 6, ConfigSetting.ALL_BRANDS, 63);
		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setEmailAddress(emailAddress);
		emailDetails.setSource("QUOTE");
		
		try {
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE", request.getRemoteAddr());
		} catch (EmailDetailsException e) {
			throw new SendEmailException("Failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress + " transactionId:" + transactionId, e);
		}
		
		if(!isTestEmailAddress) {
			emailSender.sendToExactTarget(new LifeBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId));
		}
	}
	
	private LifeBestPriceEmailModel buildBestPriceEmailModel(EmailMaster emailDetails, long transactionId) throws SendEmailException {
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		Data data = getDataObject(transactionId);
		LifeBestPriceEmailModel emailModel = new LifeBestPriceEmailModel();
		buildEmailModel(emailDetails, emailModel);

		try {
			emailModel.setFirstName((String) data.get("life/primary/firstName"));
			emailModel.setLastName((String) data.get("life/primary/lastname"));
			emailModel.setLifeCover((String) data.get("life/primary/insurance/term"));
			emailModel.setTPDCover((String) data.get("life/primary/insurance/tpd"));
			emailModel.setTraumaCover((String) data.get("life/primary/insurance/trauma"));
			emailModel.setGender((String) data.get("life/primary/gender"));
			emailModel.setAge((String) data.get("life/primary/age"));
			emailModel.setSmoker((String) data.get("life/primary/smoker"));
			emailModel.setLeadNumber((String) data.get("life/rankingDetails/leadNumber"));
			emailModel.setPremium((String) data.get("life/rankingDetails/premium"));
			emailModel.setOccupation((String) data.get("life/primary/occupationName"));
		} catch (EnvironmentException | VerticalException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}
		
		if(optedIn) {
			setCustomerKey(emailModel, optInMailingName, false);
		} else {
			setCustomerKey(emailModel, mailingName, false);
		}

		return emailModel;
	}
	
	/**
	 * Because Life sends out the best price email as part of a CRON job (instead of on a user's activity)
	 * we need to manually grab the data for the requested transaction as there is no active session
	 * @param transactionId
	 * @return
	 */
	private Data getDataObject(long transactionId) {
		Data data = new Data();
		
		TransactionDetailsDao tdDao = new TransactionDetailsDao();
		List<TransactionDetail> transactionDetails = null;
		try {
			transactionDetails = tdDao.getTransactionDetails(transactionId);
		} catch (DaoException e1) {
			logger.error("Could not populate life email data object with transaction details", e1);
		}
		
		for(TransactionDetail detail : transactionDetails) {
			data.put(detail.getXPath(), detail.getTextValue());
		}
		
		RankingDetailsDao rdDao = new RankingDetailsDao();
		List<RankingDetail> rankingDetails = null;
		
		try {
			rankingDetails = rdDao.getDetailsByPropertyValue(transactionId, "company", "ozicare");
		} catch (DaoException e1) {
			logger.error("Could not populate life email data object with ranking details", e1);
		}
		
		RankingDetail rankingDetail = rankingDetails.get(0);
		Map<String,String> rankingDetailProperties = rankingDetail.getProperties();		
		
		for (Entry<String, String> property : rankingDetailProperties.entrySet()) {
			String key = property.getKey();
			Object value = property.getValue();
			data.put("life/rankingDetails/" + key, value);
		}
		
		OccupationsDao oDao = new OccupationsDao();
		Occupation occupation = oDao.getOccupation((String) data.get("life/primary/occupation"));
		data.put("life/primary/occupationName", occupation.getTitle());
		
		return data;
	}

	@Override
	public void send(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		switch(emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress, transactionId);
				break;
			default:
				break;
		}
	}
	
}
