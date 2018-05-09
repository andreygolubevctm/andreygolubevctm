package com.ctm.web.core.provider.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ProviderService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderService.class);

	public static ArrayList<Provider> fetchProviders(HttpServletRequest request) {
		Boolean getOnlyActiveProviders = false;

		if(request.getParameter("getActiveProviders").equals("true"))
			getOnlyActiveProviders = true;

		ProviderDao providerDao = new ProviderDao();
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			return providerDao.getProviders(pageSettings.getVertical().getCode(), pageSettings.getBrandId(), getOnlyActiveProviders);
		}
		catch (DaoException|ConfigSettingException e) {
			LOGGER.error("Error fetching providers {}", kv("getOnlyActiveProviders", getOnlyActiveProviders), e);
		}

		return null;

	}

	public static String fetchProviders(String vertical, int brandId) {
		return fetchProviders(vertical, brandId, false);
	}

	public static String fetchProviders(String vertical, int brandId, Boolean getOnlyActiveProviders) {
		StringBuilder providerDropdown = new StringBuilder();
		ProviderDao providerDao = new ProviderDao();
		try {
			ArrayList<Provider> providers = providerDao.getProviders(vertical, brandId, getOnlyActiveProviders);

			for (Provider entry : providers) {

				providerDropdown.append("<option value='" + entry.getCode() + "'>" + entry.getName() + "</option>");
			}

		}
		catch (DaoException e) {
			LOGGER.error("Error fetching provides {},{},{}", kv("verticalId", vertical), kv("brandId", brandId),
				kv("getOnlyActiveProviders", getOnlyActiveProviders));
		}

		return providerDropdown.toString();

	}

	public static Provider getProvider(HttpServletRequest request, int providerId) {
		Date currDate = ApplicationService.getApplicationDate(request);

		ProviderDao providerDao = new ProviderDao();
		try {
			return providerDao.getById(providerId, currDate);
		}
		catch (DaoException e) {
			LOGGER.error("Error fetching provider by ID {}", kv("providerId", providerId), e);
		}

		return null;
	}

	public static String getProperty(HttpServletRequest request, int providerId, String propertyId) {
		Provider provider = getProvider(request, providerId);
		if(provider != null) {
			return provider.getPropertyDetail(propertyId);
		}
		return null;
	}
}
