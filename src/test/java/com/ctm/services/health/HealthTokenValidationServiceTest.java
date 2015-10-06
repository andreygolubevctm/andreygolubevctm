package com.ctm.services.health;

import com.ctm.model.Touch;
import com.ctm.model.request.health.HealthRequest;
import com.ctm.security.TransactionVerifier;
import com.ctm.services.SessionDataService;
import com.ctm.web.validation.health.HealthTokenValidationService;
import org.junit.Before;
import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;

public class HealthTokenValidationServiceTest {
    private SessionDataService sessionDataService = mock(SessionDataService.class);
    private String validToken;
    private String expiredToken;
    private String tokenWrongStep;

    private HealthRequest healthRequest;
    private HealthTokenValidationService healthQuoteResultsService;

    @Before
    public void setup() {
        TransactionVerifier transactionVerifier = new TransactionVerifier();
        long transactionId = 2313151L;
        expiredToken =  transactionVerifier.createToken("test" , transactionId, Touch.TouchType.NEW, 0, -1000);
        validToken = transactionVerifier.createToken("test" , transactionId, Touch.TouchType.NEW, 0, 300000000);
        tokenWrongStep = transactionVerifier.createToken("test" , transactionId, Touch.TouchType.APPLY, 0, 300000000);
        healthRequest = new HealthRequest();
        healthRequest.setToken(validToken);
        healthRequest.setTransactionId(transactionId);
        healthRequest.setIsCallCentre(false);
        healthQuoteResultsService = new HealthTokenValidationService(sessionDataService);
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
