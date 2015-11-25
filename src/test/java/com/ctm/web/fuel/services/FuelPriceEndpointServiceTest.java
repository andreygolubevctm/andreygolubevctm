package com.ctm.web.fuel.services;

import com.ctm.web.core.model.PageRequest;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.validation.TokenValidation;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class FuelPriceEndpointServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);
    private PageSettings pageSettings = new PageSettings();

    @Test
    public void shouldInitToken() throws Exception {
        HttpSession session = mock(HttpSession.class);
        when(request.getSession()).thenReturn(session);
        TokenValidation<PageRequest> tokenService = mock(TokenValidation.class);
        FuelPriceEndpointService fuelPriceService = new FuelPriceEndpointService(tokenService);

        when(tokenService.validateToken(anyObject())).thenReturn(true);
        fuelPriceService.init(request, pageSettings);
        assertTrue(fuelPriceService.isValidToken());

    }
}