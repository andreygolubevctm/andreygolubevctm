package com.ctm.web;

import com.ctm.model.Touch;
import com.ctm.model.settings.PageSettings;
import com.ctm.security.TransactionVerifier;
import com.ctm.utils.RequestUtils;

import javax.servlet.http.HttpServletRequest;

public class NewPage {

    public String createTokenForNewPage(HttpServletRequest request, Long transactionId, PageSettings pageSettings){
        TransactionVerifier transactionVerifier = new TransactionVerifier();
        int secondsUntilNextToken;
        // no minimum seconds until next token if preload or loading a quote
        if(RequestUtils.isTestIp(request) || isPreload(request) || isAction(request)) {
            secondsUntilNextToken =0;
        } else {
            switch (pageSettings.getVertical().getType()) {
                case HEALTH:
                    secondsUntilNextToken = 20;
                    break;
                case FUEL:
                    secondsUntilNextToken = getSecondsUntilNextTokenFuel(request);
                    break;
                default:
                    secondsUntilNextToken = 0;
            }
        }
        return transactionVerifier.createToken(request.getServletPath(), transactionId, Touch.TouchType.NEW, secondsUntilNextToken);
    }

    private boolean isAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action != null && !action.isEmpty();
    }

    private boolean isPreload(HttpServletRequest request) {
        String preLoad = request.getParameter("preload");
        return preLoad != null && preLoad.equals("true");
    }

    public int getSecondsUntilNextTokenFuel(HttpServletRequest request) {
        String fuelLocation = request.getParameter("fuel_location");
        String fuelType = request.getParameter("fueltype");
        if(  (fuelLocation != null && !fuelLocation.isEmpty()) && (fuelType != null && !fuelType.isEmpty())) {
            return 0;
        } else {
            return 5;
        }
    }

}
