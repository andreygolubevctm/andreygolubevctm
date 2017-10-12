package com.ctm.web.core.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

public class ProviderDetailsService {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProviderDetailsService.class);
    private ProviderDao providerNames;

    public void init(HttpServletRequest request) {

        try {
            providerNames = new ProviderDao();
            PageSettings pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
            Vertical vertical = pageSettings.getVertical(); // grab the vertical details
            providerNames.setProviderNames(vertical.getType().toString(), pageSettings.getBrandId());
        } catch (DaoException |ConfigSettingException e) {
            LOGGER.error("Failed initializing provider details service",e);
        }
    }

    public ArrayList<String> getProviderNames() {
        return providerNames.getProviderNames();
    }
}
