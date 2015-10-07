package com.ctm.services.fuel;

import com.ctm.model.PageRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.validation.TokenValidation;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class FuelPriceServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);
    private PageSettings pageSettings = new PageSettings();

    @Test
    public void shouldValidateToken() throws Exception {
        HttpSession session = mock(HttpSession.class);
        when(request.getSession()).thenReturn(session);
        TokenValidation<PageRequest> tokenService = mock(TokenValidation.class);
        FuelPriceService fuelPriceService = new FuelPriceService(tokenService);

        when(tokenService.validateToken(anyObject())).thenReturn(true);
        fuelPriceService.init(request, pageSettings);
        assertTrue(fuelPriceService.validToken());

        when(tokenService.validateToken(anyObject())).thenReturn(false);
        fuelPriceService.init(request, pageSettings);
        assertFalse(fuelPriceService.validToken());
        when(tokenService.isValidToken()).thenReturn(false);

    }
}