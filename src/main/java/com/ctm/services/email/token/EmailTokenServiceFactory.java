package com.ctm.services.email.token;

import com.ctm.dao.EmailMasterDao;
import com.ctm.dao.EmailTokenDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SettingsService;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by voba on 15/10/2015.
 */
public class EmailTokenServiceFactory {

    public static final String EMAIL_TOKEN_ENCRYPTION_KEY = "emailTokenEncryptionKey";

    public static EmailTokenService getEmailTokenServiceInstance(PageSettings pageSettings) throws ConfigSettingException {
        String tokenEncryptionKey = pageSettings.getSetting(EMAIL_TOKEN_ENCRYPTION_KEY);
        EmailTokenDao emailTokenDao = new EmailTokenDao();
        EmailMasterDao emailMasterDao = new EmailMasterDao();

        return new EmailTokenService(tokenEncryptionKey, emailTokenDao, emailMasterDao);
    }

    /**
     * Called from load_from_email.jsp
     */
    public static EmailTokenService getEmailTokenServiceInstanceAlt(HttpServletRequest request) throws ConfigSettingException, DaoException {
        PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, Vertical.VerticalType.GENERIC.getCode());
        return getEmailTokenServiceInstance(pageSettings);
    }
}
