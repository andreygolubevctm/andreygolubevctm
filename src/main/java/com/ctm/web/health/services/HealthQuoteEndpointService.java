package com.ctm.web.health.services;

import com.ctm.web.health.model.request.HealthRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CTMEndpointService;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.health.utils.HealthRequestParser;
import com.ctm.web.health.validation.HealthTokenValidationService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;

/**
 * TODO: move code away from health_quote_results.jsp and turn this into a router
 */
public class HealthQuoteEndpointService extends CTMEndpointService {

    private final SessionDataService sessionDataService;
    private final RequestService requestService;

    /**
     * used by health_quote_results.jsp
     */
    @SuppressWarnings("unused")
    public HealthQuoteEndpointService() {
        sessionDataService = new SessionDataService();
        this.requestService = new RequestService(Vertical.VerticalType.HEALTH );
    }

    public HealthQuoteEndpointService(HealthTokenValidationService tokenService, RequestService requestService) {
        sessionDataService = new SessionDataService();
        this.tokenService = tokenService;
        this.requestService = requestService;
    }

    public void init(HttpServletRequest httpRequest, PageSettings pageSettings) throws JspException {
        requestService.setRequest(httpRequest);
        HealthRequest request = HealthRequestParser.getHealthRequestToken(requestService, SessionUtils.isCallCentre(httpRequest.getSession()));
        if (tokenService == null) {
            this.tokenService = new HealthTokenValidationService(new SettingsService(httpRequest) , sessionDataService, pageSettings.getVertical());
        }
        super.validateToken(httpRequest, tokenService, request);
    }


}
