package com.ctm.utils.health;

import com.ctm.model.request.health.HealthRequest;
import com.ctm.services.RequestService;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

public class HealthRequestParser {

    @NotNull
    public static HealthRequest getHealthRequestToken(HttpServletRequest httpRequest, RequestService requestService) {
        HealthRequest healthRequest = new HealthRequest();
        requestService.parseCommonValues(healthRequest);
        healthRequest.setIsCallCentre(HealthRequestParser.isCallCentre(httpRequest));
        return healthRequest;
    }


    public static boolean isCallCentre(HttpServletRequest httpRequest) {
        Boolean callCentreObj = (Boolean)httpRequest.getSession().getAttribute("callCentre");
        return callCentreObj != null && callCentreObj;
    }
}
