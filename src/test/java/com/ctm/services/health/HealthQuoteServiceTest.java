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
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthQuoteServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);
    private javax.servlet.http.HttpSession session = mock(HttpSession.class);
    private RequestService requestService = mock(RequestService.class);

    @Test
    public void shouldValidateToken() throws Exception {
        Vertical vertical = new Vertical();
        PageSettings pageSettings = new PageSettings();
        pageSettings.setVertical(vertical);

        when(request.getSession()).thenReturn(session);

        HealthTokenValidationService tokenService = mock(HealthTokenValidationService.class);
        HealthQuoteService healthQuoteService = new HealthQuoteService(tokenService, requestService);

        when(tokenService.isValidToken()).thenReturn(true);
        healthQuoteService.init(request, pageSettings);
        assertTrue(healthQuoteService.validToken());

        when(tokenService.isValidToken()).thenReturn(false);
        healthQuoteService.init(request, pageSettings);
        assertFalse(healthQuoteService.validToken());
        when(tokenService.isValidToken()).thenReturn(false);

    }
}