package com.ctm.services;

import com.ctm.dao.ProviderCodesDao;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

public class LogoGridService {
	private static final Logger logger = Logger.getLogger(LogoGridService.class.getName());
	private ProviderCodesDao providerCodes;

	// this is done this way because the usebean call only calls a zero parameter constructor.
	public void init(HttpServletRequest request) {

		try {
			providerCodes = new ProviderCodesDao();
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
			Vertical vertical = pageSettings.getVertical(); // grab the vertical details
			providerCodes.setProviderCodes(vertical.getType().toString(), pageSettings.getBrandId()); // populate the
		}
		catch (Exception e) {
			logger.error(e);
		}
	}

	public void setMaxProviders(int maxProviders) {
		providerCodes.setMaxProviders(maxProviders);
	}

	public ArrayList<String>getMaxProviderCodes() {
		return providerCodes.getMaxProviderCodes();
	}

	public ArrayList<String> getAllProviderCodes() {
		return providerCodes.getAllProviderCodes();
	}
}
