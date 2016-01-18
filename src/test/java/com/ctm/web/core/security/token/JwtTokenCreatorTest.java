package com.ctm.web.core.security.token;


import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.request.TokenRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.token.config.TokenCreatorConfig;
import com.ctm.web.core.security.token.exception.InvalidTokenException;
import com.ctm.web.core.services.SettingsService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.Jwts;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;

import static junit.framework.Assert.assertNotSame;
import static junit.framework.TestCase.assertFalse;
import static junit.framework.TestCase.fail;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class JwtTokenCreatorTest {

    private JwtTokenCreator jwtTokenCreator;
    private Long transactionId = 1000L;
    private String source = "test";
    private TokenRequest tokenRequest;
    private JwtTokenValidator transactionVerifier;
    private String secretKey = "abc123ABCYusG2Pl7z-I8IiVPjHZfo-EGfWNOXSF";
    private TokenCreatorConfig config;
    private String verticalCode = Vertical.VerticalType.HEALTH.getCode();

    @Before
    public void setup() throws DaoException {
        config = new TokenCreatorConfig();
        config.setSecondsUntilNextToken(0L);
        config.setTouchType(Touch.TouchType.NEW);
        config.setVertical(verticalCode);
        SettingsService settingsService = mock(SettingsService.class);
        Vertical vertical = mock(Vertical.class);
        when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);
        when(settingsService.getVertical(verticalCode)).thenReturn(vertical);
        jwtTokenCreator = new JwtTokenCreator( settingsService , config);
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
        token = jwtTokenCreator.createToken(source, transactionId, 1000);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.LEAD_FEED));


        config.setTouchType(Touch.TouchType.APPLY);
        token = jwtTokenCreator.createToken(source, transactionId, 1000);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.APPLY));

    }

    @Test
    public void testCreateNotBefore() throws InvalidTokenException {
        config.setSecondsUntilNextToken(10000L);
        String token = jwtTokenCreator.createToken(source, transactionId, 1000000000);
        tokenRequest.setToken(token);
        // throws exception if invalid
        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));
            fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }
    }

    @Test
    public void testRefreshToken() throws InvalidTokenException {
        config.setSecondsUntilNextToken(0L);
        String token = jwtTokenCreator.createToken(source, transactionId, 10);
        JwtParser parser = Jwts.parser().setSigningKey(secretKey.getBytes());
        Claims decodedPayloadToken = parser.parseClaimsJws(token).getBody();


        String newToken = jwtTokenCreator.refreshToken(token, 10000);
        assertNotSame(token, newToken);

        Claims decodedPayloadNewToken = parser.parseClaimsJws(newToken).getBody();
        assertTrue(decodedPayloadNewToken.getExpiration().after(decodedPayloadToken.getExpiration()));


        String newTokenTwo = jwtTokenCreator.refreshToken(token, 100000);
        assertNotSame(newToken,newTokenTwo);

        Claims decodedPayloadNewTokenTwo = parser.parseClaimsJws(newTokenTwo).getBody();
        assertTrue(decodedPayloadNewTokenTwo.getExpiration().after(decodedPayloadNewToken.getExpiration()));
    }

}