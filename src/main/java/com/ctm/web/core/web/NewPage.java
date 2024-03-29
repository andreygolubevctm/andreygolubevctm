package com.ctm.web.core.web;

import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.token.config.TokenConfigFactory;
import com.ctm.web.core.security.token.config.TokenCreatorConfig;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.validation.TokenValidation;

import javax.servlet.http.HttpServletRequest;

public class NewPage {

    private final SessionDataService sessionDataService = new SessionDataService();
    private boolean enabled;

    public String createTokenForNewPage(HttpServletRequest request, Long transactionId, PageSettings pageSettings) {
        if(enabled) {
            Touch.TouchType touchType = Touch.TouchType.NEW;
            SettingsService settingsService = new SettingsService(request);
            TokenCreatorConfig config = TokenConfigFactory.getInstance(pageSettings.getVertical(), touchType, request);
            return TokenValidation.createToken(transactionId, sessionDataService, settingsService, config, request.getServletPath(), request);
        }
        return "";
    }

    public void init(HttpServletRequest request, PageSettings pageSettings){
        enabled = TokenConfigFactory.getEnabled(pageSettings.getVertical()) && !SessionUtils.isCallCentre(request.getSession());
    }

    public boolean isTokenEnabled(){
        return enabled;
    }


}
