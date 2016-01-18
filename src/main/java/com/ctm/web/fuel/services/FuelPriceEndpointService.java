package com.ctm.web.fuel.services;

import com.ctm.web.core.model.PageRequest;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.CTMEndpointService;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.validation.ResultsTokenValidation;
import com.ctm.web.core.validation.TokenValidation;

import javax.servlet.http.HttpServletRequest;

/**
 * TODO: move code from fuel_price_results.jsp and turn this into a Router
 */
public class FuelPriceEndpointService extends CTMEndpointService {

    private TokenValidation<PageRequest> tokenService;
    private final SessionDataService sessionDataService;

    /**
     * used by fuel_price_results.jsp
     */
    @SuppressWarnings("unused")
    public FuelPriceEndpointService() {
        this.sessionDataService = new SessionDataService();
    }

    public FuelPriceEndpointService(TokenValidation<PageRequest> tokenService) {
        this.tokenService = tokenService;
        this.sessionDataService = new SessionDataService();
    }

    public void init(HttpServletRequest httpRequest,  PageSettings pageSettings) {
        if(tokenService == null) {
            this.tokenService = new ResultsTokenValidation<>(new SettingsService(httpRequest), sessionDataService, pageSettings.getVertical());
        }
        super.validateToken(httpRequest, tokenService, parseRequest(httpRequest, pageSettings));
    }

    private PageRequest parseRequest(HttpServletRequest httpRequest, PageSettings pageSettings) {
        RequestService requestService = new RequestService(httpRequest, Vertical.VerticalType.FUEL, pageSettings);
        PageRequest request = new PageRequest();
        requestService.parseCommonValues(request);
        return request;
    }

}
