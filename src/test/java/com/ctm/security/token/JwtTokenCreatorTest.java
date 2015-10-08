package com.ctm.security.token;


import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.security.token.exception.InvalidTokenException;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;

import static junit.framework.TestCase.assertFalse;
import static junit.framework.TestCase.fail;

public class JwtTokenCreatorTest {

    private JwtTokenCreator jwtTokenCreator;
    private Long transactionId = 1000L;
    private String source = "test";
    private TokenRequest tokenRequest;
    private JwtTokenValidator transactionVerifier;
    private String secretKey = "test";
    private TokenCreatorConfig config;

    @Before
    public void setup() {
        config = new TokenCreatorConfig();
        config.setSecondsUntilNextToken(0L);
        config.setTouchType(Touch.TouchType.NEW);
        jwtTokenCreator = new JwtTokenCreator( config,  secretKey);
        transactionVerifier = new JwtTokenValidator( secretKey);
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
    public void shouldCreateValidToken() throws Exception {
        String token = jwtTokenCreator.createToken(source ,  transactionId , 10);
        assertFalse(token.isEmpty());
        tokenRequest.setToken(token);

        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.NEW));

        config.setTouchType(Touch.TouchType.LEAD_FEED);
        token = jwtTokenCreator.createToken(source, transactionId);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.LEAD_FEED));


        config.setTouchType(Touch.TouchType.APPLY);
        token = jwtTokenCreator.createToken(source, transactionId);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.APPLY));

    }

    @Test
    public void testCreateNotBefore() throws InvalidTokenException {
        config.setSecondsUntilNextToken(10000L);
        String token = jwtTokenCreator.createToken(source, transactionId);
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