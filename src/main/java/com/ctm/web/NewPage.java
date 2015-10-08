package com.ctm.web;

import com.ctm.model.Touch;
import com.ctm.model.settings.PageSettings;
import com.ctm.security.token.config.TokenConfigFactory;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.TokenValidation;

import javax.servlet.http.HttpServletRequest;

public class NewPage {

    private final SessionDataService sessionDataService = new SessionDataService();
    private boolean enabled;

    public String createTokenForNewPage(HttpServletRequest request, Long transactionId, PageSettings pageSettings) {
        if(enabled) {
            Touch.TouchType touchType = Touch.TouchType.NEW;
            return TokenValidation.createToken(request, transactionId, pageSettings.getVertical(), touchType, sessionDataService);
        }
        return "";
    }

    public void init(PageSettings pageSettings){
        enabled = TokenConfigFactory.getEnabled(pageSettings.getVertical());
    }

    public boolean isTokenEnabled(){
        return enabled;
    }


}
