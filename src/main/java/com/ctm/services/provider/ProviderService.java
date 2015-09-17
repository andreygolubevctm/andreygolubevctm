package com.ctm.services.provider;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;

import static com.ctm.logging.LoggingArguments.kv;

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
}
