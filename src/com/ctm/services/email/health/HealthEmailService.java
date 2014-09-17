package com.ctm.services.email.health;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.ContentDao;
import com.ctm.dao.RankingDetailsDao;
import com.ctm.dao.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.EmailDetailsException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.EmailDetails;
import com.ctm.model.RankingDetail;
import com.ctm.model.email.BestPriceRanking;
import com.ctm.model.email.HealthBestPriceEmailModel;
import com.ctm.model.formatter.email.health.HealthBestPriceExactTargetFormatter;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ApplicationService;
import com.ctm.services.ScrapesService;
import com.ctm.services.UnsubscribeService;
import com.ctm.services.email.BestPriceEmailHandler;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.ExactTargetEmailSender;

public class HealthEmailService extends EmailServiceHandler implements BestPriceEmailHandler {

	private static final String VERTICAL = VerticalType.HEALTH.getCode();

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(HealthEmailService.class.getName());

	EmailDetailsService emailDetailsService;
	protected TransactionDao transactionDao = new TransactionDao();
	private ContentDao contentDao;

	private String optInMailingName;


	public HealthEmailService(PageSettings pageSettings, EmailMode emailMode, EmailDetailsService emailDetailsService, ContentDao contentDao) {
		super(pageSettings, emailMode);
		this.emailDetailsService = emailDetailsService;
		this.contentDao = contentDao;
	}

	@Override
	public void send(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		switch (emailMode) {
			case BEST_PRICE:
				sendBestPriceEmail(request, emailAddress,transactionId);
				break;
			default:
				break;
		}
	}

	@Override
	public void sendBestPriceEmail(HttpServletRequest request, String emailAddress,
			long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getMailingName(BestPriceEmailHandler.MAILING_NAME_KEY);
		optInMailingName = getMailingName(BestPriceEmailHandler.OPT_IN_MAILING_NAME);
		ExactTargetEmailSender<HealthBestPriceEmailModel> emailSender = new ExactTargetEmailSender<HealthBestPriceEmailModel>(pageSettings);
		try {
			EmailDetails emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(request,
						emailAddress, transactionId, "QUOTE");
			if(!isTestEmailAddress) {
				emailSender.sendToExactTarget(new HealthBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId));
			}
		} catch (EmailDetailsException e) {
			throw new SendEmailException("failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress +
						" transactionId:" +  transactionId  ,  e);
		}
	}

	private HealthBestPriceEmailModel buildBestPriceEmailModel(EmailDetails emailDetails, long transactionId) throws SendEmailException {
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		HealthBestPriceEmailModel emailModel = new HealthBestPriceEmailModel();
		emailModel.setEmailAddress(emailDetails.getEmailAddress());
		emailModel.setBrand(pageSettings.getBrandCode());
		try {
			emailModel.setCallcentreHours(ScrapesService.getCallCentreHours());
			emailModel.setFirstName(emailDetails.getFirstName());
			emailModel.setOptIn(optedIn);
			emailModel.setPhoneNumber(contentDao.getByKey("healthCallCentreNumber", ApplicationService.getServerDate(), false).getContentValue());
			setupRankingDetails(emailModel , transactionId);
			emailModel.setTransactionId(transactionId);
			emailModel.setUnsubscribeURL(UnsubscribeService.getUnsubscribeUrl(pageSettings, emailDetails));
			emailModel.setApplyUrl(pageSettings.getBaseUrl() + "load_from_email.jsp?action=load&type=bestprice&id=" + transactionId + "&hash=" + emailDetails.getHashedEmail() + "&vertical=health");
		} catch (DaoException|EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to buildBestPriceEmailModel emailAddress:" + emailDetails.getEmailAddress() +
					" transactionId:" +  transactionId  ,  e);
		}
		if(optedIn) {
			setCustomerKey(emailModel,optInMailingName);
		} else {
			setCustomerKey(emailModel, mailingName);
		}
		return emailModel;
	}

	private void setupRankingDetails(HealthBestPriceEmailModel emailModel, Long transactionId) throws DaoException, SendEmailException {
		RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
		List<RankingDetail> ranking = rankingDetailsDao.getLastestTopFiveRankings(transactionId);
		if(ranking.size() > 0){
			emailModel.setPremiumFrequency(ranking.get(0).getProperty("frequency"));
			emailModel.setCoverType1(ranking.get(0).getProperty("productName"));
		} else {
			throw new SendEmailException("no rankings found transactionId:" + transactionId);
		}

		ArrayList<BestPriceRanking> bestPriceRankings = new ArrayList<BestPriceRanking>();
		for(RankingDetail rankingDetail : ranking) {
			BestPriceRanking bestPriceRanking = new BestPriceRanking();
			bestPriceRanking.setPremium(rankingDetail.getProperty("premium"));
			bestPriceRanking.setPremiumText(rankingDetail.getProperty("premiumText"));
			bestPriceRanking.setProviderName(rankingDetail.getProperty("providerName"));
			bestPriceRanking.setSmallLogo(rankingDetail.getProperty("provider").toLowerCase() + ".png");
			bestPriceRankings.add(bestPriceRanking);
		}
		emailModel.setRankings(bestPriceRankings);
	}

}