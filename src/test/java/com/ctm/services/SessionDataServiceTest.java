package com.ctm.services;

import com.ctm.model.session.SessionData;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.utils.RequestUtils;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Optional;

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
        PageSettings pageSettings = mock(PageSettings.class);
        Vertical vertical = mock(Vertical.class);
        when(pageSettings.getVertical()).thenReturn(vertical);
        when(vertical.getSettingValueForName("jwtEnabled")).thenReturn("true");
        SessionDataService sessionDataService = new SessionDataService(jwtTokenCreator,  pageSettings);

        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("");
        Optional<String> updatedToken = sessionDataService.updateToken(request);
        assertTrue(!updatedToken.isPresent());


        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn("test");
        updatedToken = sessionDataService.updateToken(request);
        String updatedTokenResult = updatedToken.get();
        assertEquals(refreshedToken, updatedTokenResult);
    }
}