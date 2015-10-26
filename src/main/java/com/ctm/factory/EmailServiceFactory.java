package com.ctm.factory;

import com.ctm.dao.*;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.EnvironmentException;
import com.ctm.exceptions.SendEmailException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.email.EmailMode;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.AccessTouchService;
import com.ctm.services.SessionDataService;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.EmailUrlService;
import com.ctm.services.email.EmailUrlServiceOld;
import com.ctm.services.email.health.HealthEmailService;
import com.ctm.services.email.life.LifeEmailService;
import com.ctm.services.email.mapping.EmailDetailsMappings;
import com.ctm.services.email.mapping.HealthEmailDetailMappings;
import com.ctm.services.email.mapping.LifeEmailDetailMappings;
import com.ctm.services.email.mapping.TravelEmailDetailMappings;
import com.ctm.services.email.token.EmailTokenService;
import com.ctm.services.email.token.EmailTokenServiceFactory;
import com.ctm.services.email.travel.TravelEmailService;
import com.disc_au.web.go.Data;

public class EmailServiceFactory {

	public static EmailServiceHandler newInstance(PageSettings pageSettings, EmailMode mode, Data data) throws SendEmailException{
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
				emailService = getLifeEmailService(pageSettings, mode, data, vertical);
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

	private static EmailServiceHandler getHealthEmailService(
			PageSettings pageSettings, EmailMode mode, Data data, VerticalType vertical) throws SendEmailException {
		ContentDao contentDao = new ContentDao(pageSettings.getBrandId(), pageSettings.getVertical().getId());
		EmailDetailsService emailDetailsService = createEmailDetailsService(pageSettings, data, vertical ,  new HealthEmailDetailMappings());
		EmailUrlService urlService = createEmailUrlService(pageSettings, vertical);
		EmailUrlServiceOld urlServiceOld = createEmailUrlServiceOld(pageSettings, vertical);
		SessionDataService sessionDataService = new SessionDataService();
		TouchDao dao = new TouchDao();
		AccessTouchService accessTouchService = new AccessTouchService(dao , sessionDataService);
		return new HealthEmailService(pageSettings, mode , emailDetailsService, contentDao, urlService , accessTouchService, urlServiceOld);
	}

	private static EmailServiceHandler getTravelEmailService(
		PageSettings pageSettings, EmailMode mode, Data data, VerticalType vertical) throws SendEmailException {
		EmailDetailsService emailDetailsService = createEmailDetailsService(
				pageSettings, data, vertical, new TravelEmailDetailMappings());
		EmailUrlService urlService = createEmailUrlService(pageSettings,
				vertical);
		EmailUrlServiceOld urlServiceOld = createEmailUrlServiceOld(pageSettings, vertical);
		return new TravelEmailService(pageSettings, mode , emailDetailsService, urlService, data, urlServiceOld);
	}
	
	private static EmailServiceHandler getLifeEmailService(PageSettings pageSettings, EmailMode mode, Data data, VerticalType vertical) throws SendEmailException {
		EmailDetailsService emailDetailsService = createEmailDetailsService(pageSettings, data, vertical, new LifeEmailDetailMappings());
		EmailUrlService urlService = createEmailUrlService(pageSettings, vertical);
		return new LifeEmailService(pageSettings, mode, emailDetailsService, urlService);
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
