package com.ctm.web.factory;

import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.dao.StampingDao;
import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.mapping.EmailDetailsMappings;
import com.ctm.web.core.email.mapping.LifeEmailDetailMappings;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailServiceHandler;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.email.services.EmailUrlServiceOld;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.services.token.EmailTokenServiceFactory;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.email.mapping.HealthEmailDetailMappings;
import com.ctm.web.health.email.services.HealthEmailService;
import com.ctm.web.life.dao.OccupationsDao;
import com.ctm.web.life.email.services.LifeEmailDataService;
import com.ctm.web.life.email.services.LifeEmailService;
import com.ctm.web.travel.email.services.TravelEmailService;
import com.ctm.web.travel.services.email.TravelEmailDetailMappings;

public class EmailServiceFactory {

	public static EmailServiceHandler newInstance(PageSettings pageSettings, EmailMode mode, Data data, IPAddressHandler ipAddressHandler) throws SendEmailException{
		VerticalType vertical = pageSettings.getVertical().getType();

		EmailServiceHandler emailService = null;
		
		switch (vertical) {
			case HEALTH:
				emailService = getHealthEmailService(pageSettings, mode, data , vertical);
				break;
			case TRAVEL:
				emailService = getTravelEmailService(pageSettings, mode, data , vertical);
				break;
			case LIFE:
				emailService = getLifeEmailService(pageSettings, mode, data, vertical, ipAddressHandler);
				break;
			case HOME:
				// TODO: refactor this
				break;
			case CAR:
				// TODO: refactor this
				break;
			case GENERIC:
				// TODO: refactor this
				break;
			default:
				break;
		}
		return emailService;
	}

	public static EmailServiceHandler newInstance(PageSettings pageSettings, EmailMode mode, Data data) throws SendEmailException {
		return newInstance( pageSettings,  mode,  data, IPAddressHandler.getInstance());
	}

	private static EmailServiceHandler getHealthEmailService(
			PageSettings pageSettings, EmailMode mode, Data data, VerticalType vertical) throws SendEmailException {
		ContentDao contentDao = new ContentDao(pageSettings.getBrandId(), pageSettings.getVertical().getId());
		EmailDetailsService emailDetailsService = createEmailDetailsService(pageSettings, data, vertical, new HealthEmailDetailMappings());
		EmailUrlService urlService = createEmailUrlService(pageSettings, vertical);
		EmailUrlServiceOld urlServiceOld = createEmailUrlServiceOld(pageSettings, vertical);
		SessionDataService sessionDataService = new SessionDataService();
		TouchDao dao = new TouchDao();
		AccessTouchService accessTouchService = new AccessTouchService(dao , sessionDataService);
		return new HealthEmailService(pageSettings, mode , emailDetailsService, contentDao, urlService , accessTouchService, urlServiceOld, sessionDataService, IPAddressHandler.getInstance());
	}

	private static EmailServiceHandler getTravelEmailService(
		PageSettings pageSettings, EmailMode mode, Data data, VerticalType vertical) throws SendEmailException {
		EmailDetailsService emailDetailsService = createEmailDetailsService(
				pageSettings, data, vertical, new TravelEmailDetailMappings());
		EmailUrlService urlService = createEmailUrlService(pageSettings,
				vertical);
		EmailUrlServiceOld urlServiceOld = createEmailUrlServiceOld(pageSettings, vertical);
		return new TravelEmailService(pageSettings, mode , emailDetailsService, urlService, data, urlServiceOld, IPAddressHandler.getInstance());
	}
	
	private static LifeEmailService getLifeEmailService(PageSettings pageSettings, EmailMode mode, Data data,
														VerticalType vertical,  IPAddressHandler ipAddressHandler) throws SendEmailException {
		EmailDetailsService emailDetailsService = createEmailDetailsService(pageSettings, data, vertical, new LifeEmailDetailMappings());
		LifeEmailDataService lifeEmailDataService = new LifeEmailDataService( new RankingDetailsDao(),
				new TransactionDetailsDao(), new OccupationsDao());
		return new LifeEmailService(pageSettings, mode, emailDetailsService,
				 lifeEmailDataService,
				new ServiceConfigurationService(),
				new ApplicationService(), ipAddressHandler);
	}

	private static EmailDetailsService createEmailDetailsService(
			PageSettings pageSettings, Data data, VerticalType vertical , EmailDetailsMappings emailDetailsMappings) {
		EmailMasterDao emailMasterDao = new EmailMasterDao(pageSettings.getBrandId(), pageSettings.getBrandCode() , vertical.getCode());
		TransactionDao transactionDao = new TransactionDao();
		StampingDao stampingDao = new StampingDao(pageSettings.getBrandId(), pageSettings.getBrandCode() , vertical.getCode());
		EmailDetailsService emailDetailsService = new EmailDetailsService(emailMasterDao, transactionDao, data, pageSettings.getBrandCode(), emailDetailsMappings, stampingDao, vertical.getCode());
		return emailDetailsService;
	}

	private static EmailUrlService createEmailUrlService(
			PageSettings pageSettings, VerticalType vertical)
			throws SendEmailException {
		EmailUrlService urlService;
		try {
			EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(pageSettings);
			urlService = new EmailUrlService(vertical, pageSettings.getBaseUrl(), emailTokenService);
		} catch (EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to create UnsubscribeService", e);
		}
		return urlService;
	}

	private static EmailUrlServiceOld createEmailUrlServiceOld(
			PageSettings pageSettings, VerticalType vertical)
			throws SendEmailException {
		EmailUrlServiceOld urlService;
		try {
			EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(pageSettings);
			urlService = new EmailUrlServiceOld(vertical, pageSettings.getBaseUrl());
		} catch (EnvironmentException | VerticalException
				| ConfigSettingException e) {
			throw new SendEmailException("failed to create UnsubscribeService", e);
		}
		return urlService;
	}

}
