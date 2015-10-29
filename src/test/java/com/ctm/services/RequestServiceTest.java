package com.ctm.services;

import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.utils.RequestUtils;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class RequestServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);

    @Test
    public void testSetRequest() throws Exception {
        String expectedToken = "token";
        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn(expectedToken);
        PageSettings pageSettings = new PageSettings();
        HttpSession session = mock(HttpSession.class);
        when(request.getSession()).thenReturn(session);
        RequestService requestService = new RequestService(Vertical.VerticalType.HEALTH, pageSettings);
        requestService.setRequest(request);

        assertEquals(expectedToken , requestService.getToken());

    }
}