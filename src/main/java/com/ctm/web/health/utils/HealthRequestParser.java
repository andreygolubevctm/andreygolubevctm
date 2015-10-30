package com.ctm.web.health.utils;

import com.ctm.web.health.model.request.HealthRequest;
import com.ctm.web.core.services.RequestService;

import javax.validation.constraints.NotNull;

public class HealthRequestParser {

    @NotNull
    public static HealthRequest getHealthRequestToken( RequestService requestService, boolean isCallCentre) {
        HealthRequest healthRequest = new HealthRequest();
        requestService.parseCommonValues(healthRequest);
        healthRequest.setIsCallCentre(isCallCentre);
        healthRequest.setToken(requestService.getToken());
        healthRequest.setTransactionId(requestService.getTransactionId());
        return healthRequest;
    }
}
