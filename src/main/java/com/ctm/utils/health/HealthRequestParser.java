package com.ctm.utils.health;

import com.ctm.model.request.health.HealthRequest;
import com.ctm.services.RequestService;

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