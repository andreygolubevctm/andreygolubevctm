package com.ctm.services.provider;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;

public class ProviderService {

	private static Logger logger = Logger.getLogger(ProviderService.class.getName());

	public static ArrayList<Provider> fetchProviders(HttpServletRequest request) {

		ProviderDao providerDao = new ProviderDao();
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			return providerDao.getProviders(pageSettings.getVertical().getCode(), pageSettings.getBrandId());
		}
		catch (Exception e) {
			logger.error(e);
		}

		return null;

	}
}
