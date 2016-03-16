package com.ctm.web.health.utils;

import com.ctm.web.health.model.request.BaseHealthRequest;
import com.ctm.web.core.services.RequestService;

import javax.validation.constraints.NotNull;

public class HealthRequestParser {

    @NotNull
    public static BaseHealthRequest getHealthRequestToken(RequestService requestService, boolean isCallCentre) {
        BaseHealthRequest healthRequest = new BaseHealthRequest();
        requestService.parseCommonValues(healthRequest);
        healthRequest.setIsCallCentre(isCallCentre);
        healthRequest.setToken(requestService.getToken());
        healthRequest.setTransactionId(requestService.getTransactionId());
        return healthRequest;
    }
}
