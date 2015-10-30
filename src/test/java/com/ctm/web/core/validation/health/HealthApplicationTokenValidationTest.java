package com.ctm.web.validation.health;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.web.health.model.request.HealthRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.web.health.validation.HealthApplicationTokenValidation;
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
    private SettingsService settingsService = mock(SettingsService.class);
    String secretKey = "secretKey";
    private TokenCreatorConfig config;
    private String verticalCode = Vertical.VerticalType.HEALTH.getCode();

    @Before
    public void setup() throws DaoException {

        Vertical vertical = mock(Vertical.class);
        when(vertical.getSettingValueForName("jwtEnabled")).thenReturn("true");
        when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);

        when(settingsService.getVertical(verticalCode)).thenReturn(vertical);
        config = new TokenCreatorConfig();
        config.setTouchType(Touch.TouchType.NEW);
        config.setVertical(verticalCode);

        SessionDataService sessionDataService = mock(SessionDataService.class);
        SettingsService settingsService = mock(SettingsService.class);
        healthApplicationTokenValidation = new HealthApplicationTokenValidation(settingsService, sessionDataService, vertical);
    }
    @Test
    public void shouldValidateToken() throws Exception {
        config.setTouchType(Touch.TouchType.PRICE_PRESENTATION);
        JwtTokenCreator jwtTokenCreator= new JwtTokenCreator(settingsService, config);

        HealthRequest request = new HealthRequest();
        request.setIsCallCentre(false);
        String token = jwtTokenCreator.createToken("test", transactionId, 1000);
        request.setToken(token);
        request.setTransactionId(transactionId);

        boolean result = healthApplicationTokenValidation.validateToken(request);

        assertTrue(result);


        config.setTouchType(Touch.TouchType.NEW);
         jwtTokenCreator= new JwtTokenCreator(settingsService, config);
        token = jwtTokenCreator.createToken("test", transactionId, 1000);
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