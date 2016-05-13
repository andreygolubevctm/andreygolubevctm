package com.ctm.web.core.content.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SettingsService;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;


@Component
public class ConfigService {

	/**
	 * Returns the value of the configCode (as a boolean) this is the one that should be called by the JSP page.
	 *
	 * @param request http servlet request which will be used to get pageSettings
	 * @param configCode must match up with what is in the database
	 * @return boolean based off config in db
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	public  boolean getConfigValueBoolean(HttpServletRequest request, String configCode) throws DaoException, ConfigSettingException {
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request, true);
		return pageSettings.getSettingAsBoolean(configCode);
	}

}
