package com.ctm.services.health;

import com.ctm.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.model.request.health.HealthRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.web.validation.health.HealthTokenValidationService;
import org.junit.Before;
import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class HealthTokenValidationServiceTest {
    private SessionDataService sessionDataService = mock(SessionDataService.class);
    private String validToken;
    private String expiredToken;
    private String tokenWrongStep;

    private HealthRequest healthRequest;
    private HealthTokenValidationService healthQuoteResultsService;
    private String secretKey = "secretKey";
    private String verticalCode = Vertical.VerticalType.HEALTH.getCode();
    private SettingsService settingsService = mock(SettingsService.class);

    @Before
    public void setup() throws DaoException {
        Vertical vertical = mock(Vertical.class);
        when(vertical.getSettingValueForName("jwtEnabled")).thenReturn("true");
        when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);

        when(settingsService.getVertical(verticalCode)).thenReturn(vertical);
        TokenCreatorConfig config = new TokenCreatorConfig();
        config.setTouchType(Touch.TouchType.NEW);
        config.setVertical(verticalCode);

        JwtTokenCreator transactionVerifier = new JwtTokenCreator(settingsService, config);
        long transactionId = 2313151L;
        expiredToken =  transactionVerifier.createToken("test" , transactionId,  -1000);
        validToken = transactionVerifier.createToken("test" , transactionId,  300000000);
        transactionVerifier = new JwtTokenCreator(settingsService, config);
        config.setTouchType(Touch.TouchType.CALL_DIRECT);
        tokenWrongStep = transactionVerifier.createToken("test" , transactionId, 300000000);
        healthRequest = new HealthRequest();
        healthRequest.setToken(validToken);
        healthRequest.setTransactionId(transactionId);
        healthRequest.setIsCallCentre(false);

        healthQuoteResultsService = new HealthTokenValidationService( settingsService,sessionDataService, vertical);
    }

    @Test
    public void testShouldReturnFalseIfTokenTimeOut() {
        healthRequest.setToken(validToken);
        assertTrue(healthQuoteResultsService.validateToken(healthRequest));
        healthRequest.setToken(expiredToken);
        assertFalse(healthQuoteResultsService.validateToken(healthRequest));
    }

    @Test
    public void testShouldReturnFalseIfWrongStep() {
        healthRequest.setToken(validToken);
        assertTrue(healthQuoteResultsService.validateToken(healthRequest));
        healthRequest.setToken(tokenWrongStep);
        assertFalse(healthQuoteResultsService.validateToken(healthRequest));
    }

    @Test
    public void testShouldReturnTrueIfSimples() {
        healthRequest.setIsCallCentre(true);
        healthRequest.setToken(validToken);
        assertTrue(healthQuoteResultsService.validateToken(healthRequest));
        healthRequest.setToken(expiredToken);
        assertTrue(healthQuoteResultsService.validateToken(healthRequest));
        healthRequest.setToken(tokenWrongStep);
        assertTrue(healthQuoteResultsService.validateToken(healthRequest));
    }
}
