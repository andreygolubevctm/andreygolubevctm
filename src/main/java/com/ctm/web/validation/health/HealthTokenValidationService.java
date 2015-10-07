package com.ctm.web.validation.health;

import com.ctm.model.request.health.HealthRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.ResultsTokenValidation;


public class HealthTokenValidationService extends ResultsTokenValidation<HealthRequest> {

    public HealthTokenValidationService(SessionDataService sessionDataService, Vertical vertical) {
       super(sessionDataService, vertical);
    }

    /**
     * Checks if the token is valid right step, not expired and valid transaction id
     * @param request jwt token to validate against
     * @return boolean to state if token is valid
     */
    @Override
    public boolean validateToken(HealthRequest request) {
        return request.isCallCentre() || super.validateToken(request);
    }

}
