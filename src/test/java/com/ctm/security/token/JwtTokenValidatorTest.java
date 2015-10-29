package com.ctm.security.token;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.web.core.model.request.TokenRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.security.token.exception.InvalidTokenException;
import com.ctm.services.SettingsService;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class JwtTokenValidatorTest {

    private JwtTokenValidator transactionVerifier;
    private Long transactionId = 1000L;
    private String source = "test";
    private TokenRequest tokenRequest;
    private String secretKey = "secretKey";
    private HttpServletRequest request;
    private SettingsService settingsService;
    private String verticalCode = Vertical.VerticalType.HEALTH.getCode();
    private TokenCreatorConfig config;

    @Before
    public void setup() throws DaoException {
        settingsService = mock(SettingsService.class);
        Vertical vertical = mock(Vertical.class);
        when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);
        when(settingsService.getVertical(verticalCode)).thenReturn(vertical);
        config = new TokenCreatorConfig();
        config.setVertical(verticalCode);
        request = Mockito.mock(HttpServletRequest.class);
        when(request.getLocalAddr()).thenReturn("10.0.0.10000");
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
    public void testValidateToken() throws InvalidTokenException {
        config.setTouchType(Touch.TouchType.BROCHURE);
        String token = new JwtTokenCreator(settingsService, config).createToken(source, transactionId, 1000);
        tokenRequest.setToken(token);
        // throws exception if invalid
        transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));

        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.CALL_FEED));
            Assert.fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }

        tokenRequest.setTransactionId(3000L);
        try {
            transactionVerifier.validateToken(tokenRequest, Arrays.asList(Touch.TouchType.BROCHURE));
            Assert.fail("Exception expected");
        } catch (InvalidTokenException e) {
            // expected
        }
    }

}