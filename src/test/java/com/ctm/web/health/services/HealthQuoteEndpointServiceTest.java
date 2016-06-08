package com.ctm.web.health.services;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.RequestService;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;
import com.ctm.web.health.validation.HealthTokenValidationService;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static junit.framework.TestCase.assertFalse;
import static junit.framework.TestCase.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthQuoteEndpointServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);
    private RequestService requestService = mock(RequestService.class);
    private HealthRequest healthRequest;
    private PageSettings pageSettings;
    private Long transactionId = 100000L;
    private HealthQuoteEndpointService healthQuoteService;
    private boolean isCallCentre = true;

    @Before
    public void setUp() throws Exception {
        healthRequest = new HealthRequest();
        HealthQuote health = new HealthQuote();
        Simples simples = new Simples();
        simples.setContactType("contactType");
        health.setSimples(simples);
        healthRequest.setHealth(health);
        Vertical vertical = mock(Vertical.class);
         pageSettings = new PageSettings();
        pageSettings.setVertical(vertical);
        HealthTokenValidationService tokenService = mock(HealthTokenValidationService.class);
         healthQuoteService = new HealthQuoteEndpointService(tokenService, requestService);

    }

    @Test
    public void shouldInitToken() throws Exception {
        HealthTokenValidationService tokenService = mock(HealthTokenValidationService.class);
        HealthQuoteEndpointService healthQuoteService = new HealthQuoteEndpointService(tokenService, requestService);

        when(tokenService.validateToken(anyObject())).thenReturn(true);
        healthQuoteService.init(request, pageSettings, healthRequest, isCallCentre);
        assertTrue(healthQuoteService.isValidToken());

    }

    @Test
    public void shouldValidateRequest() throws Exception {

        healthRequest.getHealth().getSimples().setContactType("contactType");

        healthQuoteService.init(request, pageSettings, healthRequest, isCallCentre);
        assertTrue(healthQuoteService.isValidRequest());


        healthRequest.getHealth().getSimples().setContactType(null);
        healthQuoteService.init(request, pageSettings, healthRequest, isCallCentre);
        assertFalse(healthQuoteService.isValidRequest());

    }

    @Test
    public void shouldReturnValidationString() throws Exception {
        healthRequest.getHealth().getSimples().setContactType(null);
        healthQuoteService.init(request, pageSettings, healthRequest, isCallCentre);
        assertNotNull(healthQuoteService.createErrorResponseInvalidRequest(transactionId));

    }
}