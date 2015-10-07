package com.ctm.security;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.security.exception.InvalidTokenException;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.fail;
import static org.mockito.Mockito.mock;


public class TransactionVerifierTest {

    private JwtTokenCreator transactionVerifier;
    private Long transactionId = 1000L;
    private String source = "test";
    private TokenRequest tokenRequest;

    @Before
    public void setup() {
        Vertical vertical = new Vertical();
        Touch.TouchType touchType = Touch.TouchType.NEW;
        HttpServletRequest request = mock(HttpServletRequest.class);
        transactionVerifier = new JwtTokenCreator( vertical,  touchType, request);
        tokenRequest  = new TokenRequest(){

            public Long transactionId;
            public String token;

            @Override
            public String getToken() {
                return this.token;
            }

            @Override
            public void setToken(String token) {
                this.token = token;
            }

            @Override
            public Long getTransactionId() {
                return transactionId;
            }

            @Override
            public void setTransactionId(Long transactionId) {
                this.transactionId = transactionId;

            }

        };
        tokenRequest.setTransactionId(transactionId);
    }


    @Test
    public void testValidateToken() throws InvalidTokenException {
        String token = transactionVerifier.createToken(source, transactionId, Touch.TouchType.BROCHURE);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));

        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.CALL_FEED));
            fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }

        tokenRequest.setTransactionId(3000L);
        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));
            fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }
    }


    @Test
    public void testValidateTokenNotBefore() throws InvalidTokenException {
        String token = transactionVerifier.createToken(source, transactionId, Touch.TouchType.BROCHURE);
        tokenRequest.setToken(token);
        // throws exception if invalid
        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));
            fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }
    }
}