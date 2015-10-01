package com.ctm.web.validation.health;

import com.ctm.model.Touch;
import com.ctm.model.request.health.HealthRequest;
import com.ctm.security.TransactionVerifier;
import com.ctm.services.SessionDataService;
import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;


public class HealthApplicationTokenValidationTest {

    private Long transactionId = 1000L;

    @Test
    public void shouldValidateToken() throws Exception {
        TransactionVerifier  transactionVerifier= new TransactionVerifier();
        HealthRequest request = new HealthRequest();
        request.setIsCallCentre(false);
        String token = transactionVerifier.createToken("test", transactionId, Touch.TouchType.PRICE_PRESENTATION);
        request.setToken(token);
        request.setTransactionId(transactionId);


        SessionDataService sessionDataService = mock(SessionDataService.class);
        HealthApplicationTokenValidation healthApplicationTokenValidation = new HealthApplicationTokenValidation(sessionDataService);

        boolean result = healthApplicationTokenValidation.validateToken(request);

        assertTrue(result);


         token = transactionVerifier.createToken("test", transactionId, Touch.TouchType.NEW);
        request.setToken(token);

        result = healthApplicationTokenValidation.validateToken(request);

        assertFalse(result);

    }
}