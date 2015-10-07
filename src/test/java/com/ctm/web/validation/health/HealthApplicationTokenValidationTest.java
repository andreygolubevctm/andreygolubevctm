package com.ctm.web.validation.health;

import com.ctm.model.Touch;
import com.ctm.model.request.health.HealthRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SessionDataService;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthApplicationTokenValidationTest {

    private Long transactionId = 1000L;
    private HttpServletRequest httpServletRequest = mock(HttpServletRequest.class);
    private HealthApplicationTokenValidation healthApplicationTokenValidation;
    String secretKey = "secretKey";

    @Before
    public void setup() {
        SessionDataService sessionDataService = mock(SessionDataService.class);
        Vertical vertical = mock(Vertical.class);
        when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);
        when(vertical.getSettingValueForName("jwtEnabled")).thenReturn("true");
         healthApplicationTokenValidation = new HealthApplicationTokenValidation(sessionDataService, vertical);
    }
    @Test
    public void shouldValidateToken() throws Exception {

        TokenCreatorConfig config = new TokenCreatorConfig();
        config.setTouchType(Touch.TouchType.PRICE_PRESENTATION);
        JwtTokenCreator jwtTokenCreator= new JwtTokenCreator(config, secretKey);

        HealthRequest request = new HealthRequest();
        request.setIsCallCentre(false);
        String token = jwtTokenCreator.createToken("test", transactionId);
        request.setToken(token);
        request.setTransactionId(transactionId);

        boolean result = healthApplicationTokenValidation.validateToken(request);

        assertTrue(result);


        config.setTouchType(Touch.TouchType.NEW);
         jwtTokenCreator= new JwtTokenCreator(config, secretKey);
        token = jwtTokenCreator.createToken("test", transactionId);
        request.setToken(token);

        result = healthApplicationTokenValidation.validateToken(request);

        assertFalse(result);

    }

    @Test
    public void testShouldCreateErrorResponse() throws  Exception {
        Long transactionId= 1000L;
        String errorMessage = "failed to test";
        String type = "test";
        String expectedResult = "{\"error\":{\"type\":\"" + type + "\",\"message\":\"" + errorMessage + "\"}}";
        assertEquals(expectedResult ,healthApplicationTokenValidation.createErrorResponse( transactionId,  errorMessage,  httpServletRequest,  type));
    }
}