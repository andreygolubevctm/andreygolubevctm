package com.ctm.web.core.security;

import com.ctm.web.core.content.services.ConfigService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static junit.framework.TestCase.assertNotNull;
import static org.junit.Assert.assertEquals;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;


public class IPAddressHandlerTest {

    @Mock
    ConfigService configService;
    @Mock
    private HttpServletRequest request;

    private IPAddressHandler ipAddressHandler;
    private String remoteIP = "remote IP";
    private String xForwardIP = "xForwardIP";

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        when(request.getRemoteAddr()).thenReturn(remoteIP);
        ipAddressHandler = new IPAddressHandler(configService);
    }

    @Test
    public void testGetInstance() throws Exception {
        assertNotNull(IPAddressHandler.getInstance());
    }

    @Test
    public void testShouldGetRemoteIPAddressIfForwardNotEnabled() throws Exception {
        when(configService.getConfigValueBoolean( request, "getIPFromXForward")).thenReturn(false);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(remoteIP, result);
    }


    @Test
    public void testShouldGetForwardIPAddressIfEnabled() throws Exception {
        when(request.getHeader(IPAddressHandler.FORWARD_FOR_HEADER)).thenReturn(xForwardIP);
        when(configService.getConfigValueBoolean( request, "getIPFromXForward")).thenReturn(true);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(xForwardIP, result);
    }

    @Test
    public void testShouldGetRemoteIPAddressIfGetForwardForEnabledButNoForwardFor() throws Exception {
        when(request.getHeader(IPAddressHandler.FORWARD_FOR_HEADER)).thenReturn(null);
        when(configService.getConfigValueBoolean( request, "getIPFromXForward")).thenReturn(true);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(remoteIP, result);
    }
}