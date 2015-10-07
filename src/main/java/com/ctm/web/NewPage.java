package com.ctm.web;

import com.ctm.model.Touch;
import com.ctm.model.settings.PageSettings;
import com.ctm.security.JwtTokenCreator;
import com.ctm.services.SessionDataService;

import javax.servlet.http.HttpServletRequest;

public class NewPage {

    private final SessionDataService sessionDataService = new SessionDataService();

    public String createTokenForNewPage(HttpServletRequest request, Long transactionId, PageSettings pageSettings) {
        JwtTokenCreator transactionVerifier = new JwtTokenCreator(pageSettings.getVertical(), Touch.TouchType.NEW, request);
        return transactionVerifier.createToken(request.getServletPath(), transactionId, sessionDataService.getClientSessionTimeoutSeconds(request));
    }

    public String createTokenForResults(HttpServletRequest request, Long transactionId, PageSettings pageSettings) {
        JwtTokenCreator transactionVerifier = new JwtTokenCreator(pageSettings.getVertical(), Touch.TouchType.PRICE_PRESENTATION, request);
        return transactionVerifier.createToken(request.getServletPath(), transactionId, sessionDataService.getClientSessionTimeoutSeconds(request));
    }

}
