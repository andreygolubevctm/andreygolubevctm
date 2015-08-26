package com.ctm.services.provider;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.ProviderDao;
import com.ctm.model.Provider;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SettingsService;

public class ProviderService {

	private static final Logger logger = LoggerFactory.getLogger(ProviderService.class.getName());

	public static ArrayList<Provider> fetchProviders(HttpServletRequest request) {
		Boolean getOnlyActiveProviders = false;

		if(request.getParameter("getActiveProviders") == "true")
			getOnlyActiveProviders = true;

		ProviderDao providerDao = new ProviderDao();
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
			return providerDao.getProviders(pageSettings.getVertical().getCode(), pageSettings.getBrandId(), getOnlyActiveProviders);
		}
		catch (Exception e) {
			logger.error("{}",e);
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

				providerDropdown.append("<option value='"+entry.getCode()+"'>"+entry.getName()+"</option>");
			}

		}
		catch (Exception e) {
			logger.error("{}",e);
		}

		return providerDropdown.toString();

	}
}
