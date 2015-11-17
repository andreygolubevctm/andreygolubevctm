package com.ctm.web.health.validation;

import com.ctm.web.health.model.request.HealthRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.validation.ResultsTokenValidation;


public class HealthTokenValidationService extends ResultsTokenValidation<HealthRequest> {

    public HealthTokenValidationService(SettingsService settingsService, SessionDataService sessionDataService, Vertical vertical) {
       super( settingsService, sessionDataService, vertical);
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
