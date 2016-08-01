package com.ctm.web.core.services;

import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.utils.RequestUtils;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class RequestServiceTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);

    @Mock
    private IPAddressHandler ipAddressHandler;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    public void testSetRequest() throws Exception {
        String expectedToken = "token";
        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn(expectedToken);
        PageSettings pageSettings = new PageSettings();
        HttpSession session = mock(HttpSession.class);
        when(request.getSession()).thenReturn(session);
        RequestService requestService = new RequestService(Vertical.VerticalType.HEALTH, pageSettings, ipAddressHandler);
        requestService.setRequest(request);

        assertEquals(expectedToken , requestService.getToken());

    }
}