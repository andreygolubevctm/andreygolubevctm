package com.ctm.services.health;

import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.RequestService;
import com.ctm.web.validation.health.HealthTokenValidationService;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthQuoteTokenServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);
    private javax.servlet.http.HttpSession session = mock(HttpSession.class);
    private RequestService requestService = mock(RequestService.class);

    @Test
    public void shouldValidateToken() throws Exception {
        Vertical vertical = mock(Vertical.class);
        PageSettings pageSettings = new PageSettings();
        pageSettings.setVertical(vertical);

        when(request.getSession()).thenReturn(session);

        HealthTokenValidationService tokenService = mock(HealthTokenValidationService.class);
        HealthQuoteTokenService healthQuoteTokenService = new HealthQuoteTokenService(tokenService, requestService);

        when(tokenService.validateToken(anyObject())).thenReturn(true);
        healthQuoteTokenService.init(request, pageSettings);
        assertTrue(healthQuoteTokenService.validToken());

        when(tokenService.validateToken(anyObject())).thenReturn(false);
        healthQuoteTokenService.init(request, pageSettings);
        assertFalse(healthQuoteTokenService.validToken());
        when(tokenService.validateToken(anyObject())).thenReturn(false);

    }
}