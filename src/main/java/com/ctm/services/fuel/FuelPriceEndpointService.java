package com.ctm.services.fuel;

import com.ctm.model.PageRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.CTMEndpointService;
import com.ctm.services.RequestService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.web.validation.ResultsTokenValidation;
import com.ctm.web.validation.TokenValidation;

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
        super.validateToken(httpRequest, tokenService, parseRequest(httpRequest));
    }

    private PageRequest parseRequest(HttpServletRequest httpRequest) {
        RequestService requestService = new RequestService(httpRequest, Vertical.VerticalType.FUEL);
        PageRequest request = new PageRequest();
        requestService.parseCommonValues(request);
        return request;
    }

}
