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

	public static String fetchProviders(String vertical, int brandId) {

		StringBuilder providerDropdown = new StringBuilder();
		ProviderDao providerDao = new ProviderDao();
		try {
			ArrayList<Provider> providers = providerDao.getProviders(vertical, brandId);

			for (Provider entry : providers) {

				providerDropdown.append("<option value='"+entry.getCode()+"'>"+entry.getName()+"</option>");
			}

		}
		catch (Exception e) {
			logger.error(e);
		}

		return providerDropdown.toString();

	}
}
