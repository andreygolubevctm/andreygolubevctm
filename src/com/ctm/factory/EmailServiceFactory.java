package com.ctm.factory;

import com.ctm.dao.ContentDao;
import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.TransactionDao;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.email.EmailDetailsService;
import com.ctm.services.email.EmailServiceHandler;
import com.ctm.services.email.EmailServiceHandler.EmailMode;
import com.ctm.services.email.health.HealthEmailService;
import com.ctm.services.email.mapping.HealthEmailDetailMappings;
import com.disc_au.web.go.Data;

public class EmailServiceFactory {

	public static EmailServiceHandler newInstance(PageSettings pageSettings, EmailMode mode, Data data){
		VerticalType vertical = pageSettings.getVertical().getType();

		EmailServiceHandler emailService = null;

		switch (vertical) {
			case HEALTH:
				emailService = getHealthEmailService(pageSettings, mode, data);
				break;
			case TRAVEL:
				// TODO: refactor this
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
				// TODO: refactor this
				break;
		}

		return emailService;

	}

	private static EmailServiceHandler getHealthEmailService(
			PageSettings pageSettings, EmailMode mode, Data data) {
		VerticalType vertical = pageSettings.getVertical().getType();
		EmailMasterDao emailMasterDao = new EmailMasterDao(pageSettings.getBrandId(), pageSettings.getBrandCode() , vertical.getCode());
		ContentDao contentDao = new ContentDao(pageSettings.getBrandId(), pageSettings.getVertical().getId());
		TransactionDao transactionDao = new TransactionDao();
		EmailDetailsService emailDetailsService = new EmailDetailsService(emailMasterDao, transactionDao, data, pageSettings.getBrandCode(), new HealthEmailDetailMappings());
		return new HealthEmailService(pageSettings, mode , emailDetailsService, contentDao);
	}

}
