package com.ctm.web.core.security;

import com.ctm.web.core.content.services.ConfigService;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.web.core.security.IPAddressHandler.GET_X_FORWARD_CONFIG_CODE;
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
    private String xForwardIP = "127.0.0.1";
    private String xForwardIPMultiple = xForwardIP + ", 192.168.1.1, 192.168.2.2";

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
        when(configService.getConfigValueBoolean(request, GET_X_FORWARD_CONFIG_CODE)).thenReturn(false);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(remoteIP, result);
    }

    @Test
    public void testShouldGetForwardIPAddressIfEnabled() throws Exception {
        when(request.getHeader(IPAddressHandler.FORWARD_FOR_HEADER)).thenReturn(xForwardIP);
        when(configService.getConfigValueBoolean(request, GET_X_FORWARD_CONFIG_CODE)).thenReturn(true);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(xForwardIP, result);
    }

    @Test
    public void getIPAddressFromXForwardChain() throws Exception {
        when(request.getHeader(IPAddressHandler.FORWARD_FOR_HEADER)).thenReturn(xForwardIPMultiple);
        when(configService.getConfigValueBoolean(request, GET_X_FORWARD_CONFIG_CODE)).thenReturn(true);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(xForwardIP, result);
    }

    @Test
    public void testShouldGetRemoteIPAddressIfGetForwardForEnabledButNoForwardFor() throws Exception {
        when(request.getHeader(IPAddressHandler.FORWARD_FOR_HEADER)).thenReturn(null);
        when(configService.getConfigValueBoolean(request, GET_X_FORWARD_CONFIG_CODE)).thenReturn(true);
        String result = ipAddressHandler.getIPAddress(request);
        assertEquals(remoteIP, result);
    }

    @Test
    public void testIsLocalIP1() throws Exception {
        boolean result = ipAddressHandler.isLocalIP("127.0.0.1");
        assertEquals(true, result);
    }

    @Test
    public void testIsLocalIP2() throws Exception {
        boolean result = ipAddressHandler.isLocalIP("0.0.0.0");
        assertEquals(true, result);
    }

    @Test
    public void testIsLocalIP3() throws Exception {
        boolean result = ipAddressHandler.isLocalIP("0:0:0:0:0:0:0:1");
        assertEquals(true, result);
    }

    @Test
    public void testIsIPInRange1() throws Exception {
        boolean result = ipAddressHandler.isIPInRange("202.56.60.0");
        assertEquals(true, result);
    }

    @Test
    public void testIsIPInRange2() throws Exception {
        boolean result = ipAddressHandler.isIPInRange("202.56.60.120");
        assertEquals(true, result);
    }

    @Test
    public void testIsIPInRange3() throws Exception {
        boolean result = ipAddressHandler.isIPInRange("202.56.61.255");
        assertEquals(true, result);
    }

    @Test
    public void testIsLocalIP4() throws Exception {
        boolean result = ipAddressHandler.isLocalIP("192.168.1.116");
        assertEquals(true, result);
    }

    @Test
    public void testIsLocalIP5() throws Exception {
        boolean result = ipAddressHandler.isLocalIP("10.46.41.235");
        assertEquals(true, result);
    }

    @Test
    public void testBelowMinIPInRange() throws Exception {
        boolean result = ipAddressHandler.isIPInRange("202.56.59.255");
        assertEquals(false, result);
    }

    @Test
    public void testAboveMaxIPInRange() throws Exception {
        boolean result = ipAddressHandler.isIPInRange("202.56.62.000");
        assertEquals(false, result);
    }
}