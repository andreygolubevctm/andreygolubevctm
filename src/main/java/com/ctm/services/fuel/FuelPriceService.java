package com.ctm.services.fuel;

import com.ctm.model.PageRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.ResultsTokenValidation;
import com.ctm.web.validation.TokenValidation;

import javax.servlet.http.HttpServletRequest;

/**
 * TODO: move code from fuel_price_results.jsp and turn this into a Router
 */
public class FuelPriceService {

    private boolean validToken;
    private TokenValidation<PageRequest> tokenService;
    private final SessionDataService sessionDataService;

    /**
     * used by fuel_price_results.jsp
     */
    @SuppressWarnings("unused")
    public FuelPriceService() {
        this.sessionDataService = new SessionDataService();
    }

    public FuelPriceService(TokenValidation<PageRequest> tokenService) {
        this.tokenService = tokenService;
        this.sessionDataService = new SessionDataService();
    }

    public void init(HttpServletRequest httpRequest,  PageSettings pageSettings) {
        if(tokenService == null) {
            Vertical vertical = pageSettings.getVertical();
            this.tokenService = new ResultsTokenValidation<>(sessionDataService, vertical);
        }
        PageRequest request = parseRequest(httpRequest);
        validToken = tokenService.validateToken(request);
    }

    private PageRequest parseRequest(HttpServletRequest httpRequest) {
        RequestService requestService = new RequestService(httpRequest, Vertical.VerticalType.FUEL);
        PageRequest request = new PageRequest();
        requestService.parseCommonValues(request);
        return request;
    }

    /**
     * used by fuel_price_results.jsp
     */
    @SuppressWarnings("unused")
    public boolean validToken() {
        return validToken;
    }

    /**
     * used by fuel_price_results.jsp
     */
    @SuppressWarnings("unused")
    public String createResponse(Long transactionId, String baseJsonResponse , HttpServletRequest request) {
        return tokenService.createResponse(transactionId,  baseJsonResponse ,  request);
    }
}
