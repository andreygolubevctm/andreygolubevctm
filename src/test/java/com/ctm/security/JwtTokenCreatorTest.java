package com.ctm.security;


import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

import static junit.framework.TestCase.assertFalse;
import static org.mockito.Mockito.mock;

public class JwtTokenCreatorTest {

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
    public void shouldCreateValidToken() throws Exception {
        String token = transactionVerifier.createToken(source ,  transactionId , 10);
        assertFalse(token.isEmpty());
        tokenRequest.setToken(token);

        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.NEW));

        token = transactionVerifier.createToken(source, transactionId , Touch.TouchType.LEAD_FEED);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.LEAD_FEED));


        token = transactionVerifier.createToken(source, transactionId, Touch.TouchType.APPLY);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.APPLY));

    }

}