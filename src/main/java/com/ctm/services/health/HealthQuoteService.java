package com.ctm.services.health;

import com.ctm.model.request.health.HealthRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.services.SessionDataService;
import com.ctm.utils.SessionUtils;
import com.ctm.utils.health.HealthRequestParser;
import com.ctm.web.validation.health.HealthTokenValidationService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;

/**
 * TODO: move code away from health_quote_results.jsp and turn this into a router
 */
public class HealthQuoteService {

    private final RequestService requestService;
    private final SessionDataService sessionDataService;
    private HealthTokenValidationService tokenService;

    /**
     * used by health_quote_results.jsp
     */
    @SuppressWarnings("unused")
    public HealthQuoteService() {
        sessionDataService = new SessionDataService();
        this.requestService = new RequestService(Vertical.VerticalType.HEALTH );
    }

    public HealthQuoteService(HealthTokenValidationService tokenService , RequestService requestService) {
        sessionDataService = new SessionDataService();
        this.tokenService = tokenService;
        this.requestService = requestService;
    }

    public void init(HttpServletRequest httpRequest, PageSettings pageSettings) throws JspException {
        requestService.setRequest(httpRequest);
        if(tokenService == null) {
            this.tokenService = new HealthTokenValidationService(sessionDataService, pageSettings.getVertical());
        }
        HealthRequest request = HealthRequestParser.getHealthRequestToken(requestService, SessionUtils.isCallCentre(httpRequest.getSession()));
        tokenService.validateToken(request);
    }


    /**
     * used by health_quote_results.jsp
     */
    @SuppressWarnings("unused")
    public boolean validToken() {
        return tokenService.isValidToken();
    }

    /**
     * used by health_quote_results.jsp
     */
    @SuppressWarnings("unused")
    public String createResponse(Long transactionId, String baseJsonResponse) {
        return tokenService.createResponse(transactionId,  baseJsonResponse ,  requestService.getRequest());

    }

}
