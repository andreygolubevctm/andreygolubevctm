package com.ctm.services;

import com.ctm.model.PageRequest;
import com.ctm.web.validation.TokenValidation;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class CTMEndpointServiceTest {

    private TokenValidation tokenService;
    private PageRequest pageRequest;
    private HttpServletRequest httpRequest;
    private CTMEndpointService ctmEndpointService;

    @Before
    public void setup() throws Exception {
        httpRequest = mock(HttpServletRequest.class);
        tokenService = mock(TokenValidation.class);
        pageRequest = new PageRequest();
        ctmEndpointService = new CTMEndpointService();
    }

    @Test
    public void shouldValidateInvalidToken() throws Exception {
        when(tokenService.validateToken(anyObject())).thenReturn(false);
        ctmEndpointService.validateToken(httpRequest, tokenService, pageRequest);
        assertFalse(ctmEndpointService.isValidToken());
    }

    @Test
    public void shouldValidateValidToken() throws Exception {
        when(tokenService.validateToken(anyObject())).thenReturn(true);
        ctmEndpointService.validateToken(httpRequest, tokenService, pageRequest);
        assertTrue(ctmEndpointService.isValidToken());

    }

}