package com.ctm.web.life.email.services;

import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.BestPriceEmailHandler;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.email.services.ExactTargetEmailSender;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.email.model.LifeBestPriceEmailModel;
import com.ctm.web.life.email.model.LifeBestPriceExactTargetFormatter;

import javax.servlet.http.HttpServletRequest;

public class LifeEmailService extends EmailServiceHandler implements BestPriceEmailHandler {
	
	private static final String VERTICAL = VerticalType.LIFE.getCode();

	private final EmailDetailsService emailDetailsService;
    private final ApplicationService applicationService;
    private final LifeEmailDataService lifeEmailDataService;
	private String optInMailingName;
    private ServiceConfigurationService serviceConfigurationService;

	public LifeEmailService(PageSettings pageSettings,
                            EmailMode emailMode,
                            EmailDetailsService emailDetailsService,
                            LifeEmailDataService lifeEmailDataService,
                            ServiceConfigurationService serviceConfigurationService,
                            ApplicationService applicationService, IPAddressHandler ipAddressHandler) {
		super(pageSettings, emailMode, ipAddressHandler);
		this.emailDetailsService = emailDetailsService;
        this.serviceConfigurationService = serviceConfigurationService;
        this.applicationService = applicationService;
        this.lifeEmailDataService = lifeEmailDataService;
	}

	public LifeEmailService(PageSettings pageSettings,
                            EmailMode emailMode,
                            EmailDetailsService emailDetailsService,
                            LifeEmailDataService lifeEmailDataService,
                            ServiceConfigurationService serviceConfigurationService,
                            ApplicationService applicationService) {
		super(pageSettings, emailMode, IPAddressHandler.getInstance());
		this.emailDetailsService = emailDetailsService;
		this.serviceConfigurationService = serviceConfigurationService;
		this.applicationService = applicationService;
		this.lifeEmailDataService = lifeEmailDataService;
	}

	@Override
	public String sendBestPriceEmail(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		boolean isTestEmailAddress = isTestEmailAddress(emailAddress);
		mailingName = getPageSetting(BestPriceEmailHandler.MAILING_NAME_KEY);
		optInMailingName = getPageSetting(BestPriceEmailHandler.OPT_IN_MAILING_NAME);
		Brand brand = applicationService.getBrand( request, VerticalType.LIFE);
        Vertical vertical = brand.getVerticalByCode(VERTICAL);
		ExactTargetEmailSender<LifeBestPriceEmailModel> emailSender = new ExactTargetEmailSender<>(pageSettings, transactionId,
                vertical, ConfigSetting.ALL_BRANDS, 63, serviceConfigurationService);
		EmailMaster emailDetails = new EmailMaster();
		emailDetails.setEmailAddress(emailAddress);
		emailDetails.setSource("QUOTE");
		
		try {
			emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE", ipAddressHandler.getIPAddress(request));
		} catch (EmailDetailsException e) {
			throw new SendEmailException("Failed to handleReadAndWriteEmailDetails emailAddress:" + emailAddress + " transactionId:" + transactionId, e);
		}
		
		if(!isTestEmailAddress) {
			return emailSender.sendToExactTarget(new LifeBestPriceExactTargetFormatter(), buildBestPriceEmailModel(emailDetails, transactionId));
		} else {
			return "";
		}
	}
	
	private LifeBestPriceEmailModel buildBestPriceEmailModel(EmailMaster emailDetails, long transactionId) throws SendEmailException {
		boolean optedIn = emailDetails.getOptedInMarketing(VERTICAL);
		Data data = lifeEmailDataService.getDataObject(transactionId);
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

	@Override
	public String send(HttpServletRequest request, String emailAddress, long transactionId) throws SendEmailException {
		switch(emailMode) {
			case BEST_PRICE:
				return sendBestPriceEmail(request, emailAddress, transactionId);
			default:
				break;
		}
		return "";
	}
	
}
