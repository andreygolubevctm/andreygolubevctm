package com.ctm.services;

import com.ctm.security.JwtTokenCreator;
import com.ctm.utils.RequestUtils;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SessionDataServiceTest {

    @Test
    public void testUpdateToken() throws Exception {
        long timeoutSeconds = 1000;
        JwtTokenCreator transactionVerifier = mock(JwtTokenCreator.class);

        String refreshedToken = "refreshedToken";
        when(transactionVerifier.refreshToken("test", 1000)).thenReturn(refreshedToken);
        SessionDataService sessionDataService = new SessionDataService(transactionVerifier);
        HttpServletRequest request = mock(HttpServletRequest.class);

        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("");
        String updatedToken = sessionDataService.updateToken(request, timeoutSeconds);
        assertTrue(updatedToken.isEmpty());


        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("test");
        updatedToken = sessionDataService.updateToken(request, timeoutSeconds);

        assertEquals(refreshedToken , updatedToken);
    }
}