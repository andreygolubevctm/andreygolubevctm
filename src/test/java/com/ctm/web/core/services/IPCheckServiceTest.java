package com.ctm.web.core.services;

import com.ctm.web.core.dao.IpAddressDao;
import com.ctm.web.core.model.IpAddress;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.IPAddressHandler;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class IPCheckServiceTest {

    @Mock
    HttpServletRequest request;
    @Mock
    IpAddressDao ipAddressDao;
    @Mock
    PageSettings pageSettings;
    @Mock
    private IPAddressHandler ipAddressHandler;

    private int styleCodeId = 1;
    private IPCheckService ipCheckService;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
         ipCheckService = new IPCheckService(ipAddressDao, ipAddressHandler);
    }

    @Test
    public void testIsPermittedAccessWhenPermanentBanned() throws Exception {

        IpAddress ipAddressModel = new IpAddress(0, 1, "travel", IpAddress.IpCheckRole.BANNED_USER, 1000, styleCodeId);

        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn("203.203.203.203");
        when(ipAddressDao.findMatch(pageSettings, 3419130827L)).thenReturn(ipAddressModel);
        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertFalse(permittedAccess);
    }

    @Test
    public void testIsPermittedAccessWhenAdmin() throws Exception {

        IpAddress ipAddressModel = new IpAddress(3232238418L, 3232238418L, "travel", IpAddress.IpCheckRole.ADMIN_USER, 1000, styleCodeId);

        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);
        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertTrue(permittedAccess);
    }

    @Test
    public void testIsPermittedAccessWhenTempUserPassedLimit() throws Exception {
        IpAddress ipAddressModel = new IpAddress(3232238418L, 3232238418L, "travel", IpAddress.IpCheckRole.TEMPORARY_USER, 11, styleCodeId);

        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertFalse(permittedAccess);
    }

    /**
     * When the user is at 10 requests, it should allow through. When they are at 11 it should block.
     * @throws Exception
     */
    @Test
    public void testIsPermittedAccessWhenTempUserAtLimit() throws Exception {

        IpAddress ipAddressModel = new IpAddress(3232238418L, 3232238418L, "travel", IpAddress.IpCheckRole.TEMPORARY_USER, 9, styleCodeId);

        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertTrue(permittedAccess);
    }

    /**
     * Returns true, as by default we allow if it cannot handle the IP address (null/empty IP or IPv6)
     * @throws Exception
     */
    @Test
    public void testIsPermittedAccessWhenIpIsNull() throws Exception {

        IpAddress ipAddressModel = new IpAddress(0, 1, "travel", IpAddress.IpCheckRole.TEMPORARY_USER, 5, styleCodeId);

        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn("");
        when(ipAddressDao.findMatch(pageSettings, 0)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertTrue(permittedAccess);
    }

    @Test
    public void testGetIPAddressAsLong() throws Exception {
        assertIPAddressAsLong("localhost", 0);

        assertIPAddressAsLong("127.0.0.1", 2130706433);

        assertIPAddressAsLong("192.168.11.82", 3232238418L);

        assertIPAddressAsLong("FE80:0000:0000:0000:0202:B3FF:FE1E:8329", 0);
    }

    private void assertIPAddressAsLong(String remoteIpAddress, long expectedResult) {
        when(ipAddressHandler.getIPAddress(request, pageSettings)).thenReturn(remoteIpAddress);
        long ipAddressAsLong = ipCheckService.getIPAddressAsLong(request, pageSettings);

        assertEquals(expectedResult, ipAddressAsLong);
    }


}