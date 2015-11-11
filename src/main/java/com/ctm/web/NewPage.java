package com.ctm.web;

import com.ctm.model.Touch;
import com.ctm.model.settings.PageSettings;
import com.ctm.security.token.config.TokenConfigFactory;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.utils.SessionUtils;
import com.ctm.web.validation.TokenValidation;

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
