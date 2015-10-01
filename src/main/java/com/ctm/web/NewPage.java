package com.ctm.web;

import com.ctm.model.Touch;
import com.ctm.model.settings.PageSettings;
import com.ctm.security.TransactionVerifier;

import javax.servlet.http.HttpServletRequest;

public class NewPage {

    public String createTokenForNewPage(HttpServletRequest request, Long transactionId, PageSettings pageSettings){
        TransactionVerifier transactionVerifier = new TransactionVerifier();
        int secondsUntilNextToken;
        // no leeway if preload or loading a quote
        String preload = request.getParameter("preload");
        String action = request.getParameter("action");
        if(preload != null && preload.equals("true") || (action != null && !action.isEmpty())) {
            secondsUntilNextToken = 0;
        } else {
            switch (pageSettings.getVertical().getType()) {
                case HEALTH:
                    secondsUntilNextToken = 25;
                    break;
                case FUEL:
                    secondsUntilNextToken = getSecondsUntilNextTokenFuel(request);
                    break;
                default:
                    secondsUntilNextToken = 0;
            }
        }
        return transactionVerifier.createToken(request.getServletPath(), transactionId, Touch.TouchType.NEW , secondsUntilNextToken);
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
