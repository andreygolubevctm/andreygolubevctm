package com.ctm.services;

import com.ctm.model.session.SessionData;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.utils.RequestUtils;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SessionDataServiceTest {

    @Test
    public void testUpdateToken() throws Exception {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpSession session = mock(HttpSession.class);
        SessionData sessionData = new SessionData();
        when(session.getAttribute("sessionData")).thenReturn(sessionData);
        when(request.getSession()).thenReturn(session);
        JwtTokenCreator jwtTokenCreator = mock(JwtTokenCreator.class);

        String refreshedToken = "refreshedToken";
        when(jwtTokenCreator.refreshToken(eq("test"), anyInt())).thenReturn(refreshedToken);
        SessionDataService sessionDataService = new SessionDataService(jwtTokenCreator);

        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("");
        String updatedToken = sessionDataService.updateToken(request);
        assertTrue(updatedToken.isEmpty());


        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("test");
        updatedToken = sessionDataService.updateToken(request);

        assertEquals(refreshedToken , updatedToken);
    }
}