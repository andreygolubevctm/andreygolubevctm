package com.ctm.services;

import com.ctm.dao.IpAddressDao;
import com.ctm.model.IpAddress;
import com.ctm.model.settings.PageSettings;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import java.sql.Date;
import java.util.logging.Logger;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

/**
 * Created by bthompson on 13/05/2015.
 */
public class IPCheckServiceTest {

    @Mock
    HttpServletRequest request;
    @Mock
    IpAddressDao ipAddressDao;
    @Mock
    PageSettings pageSettings;

    private int styleCodeId = 1;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
    }

    @Test
    public void testIsPermittedAccessWhenPermanentBanned() throws Exception {

        IpAddress ipAddressModel = new IpAddress(0, 1, "travel", IpAddress.IpCheckRole.BANNED_USER, 1000, styleCodeId);

        when(request.getRemoteAddr()).thenReturn("203.203.203.203");
        when(ipAddressDao.findMatch(pageSettings, 3419130827L)).thenReturn(ipAddressModel);

        IPCheckService ipCheckService = new IPCheckService(ipAddressDao);
        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertFalse(permittedAccess);
    }

    @Test
    public void testIsPermittedAccessWhenAdmin() throws Exception {

        IpAddress ipAddressModel = new IpAddress(3232238418L, 3232238418L, "travel", IpAddress.IpCheckRole.ADMIN_USER, 1000, styleCodeId);

        when(request.getRemoteAddr()).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);

        IPCheckService ipCheckService = new IPCheckService(ipAddressDao);
        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertTrue(permittedAccess);
    }

    @Test
    public void testIsPermittedAccessWhenTempUserPassedLimit() throws Exception {
        IpAddress ipAddressModel = new IpAddress(3232238418L, 3232238418L, "travel", IpAddress.IpCheckRole.TEMPORARY_USER, 11, styleCodeId);

        when(request.getRemoteAddr()).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        IPCheckService ipCheckService = new IPCheckService(ipAddressDao);
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

        when(request.getRemoteAddr()).thenReturn("192.168.11.82");
        when(ipAddressDao.findMatch(pageSettings, 3232238418L)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        IPCheckService ipCheckService = new IPCheckService(ipAddressDao);
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

        when(request.getRemoteAddr()).thenReturn("");
        when(ipAddressDao.findMatch(pageSettings, 0)).thenReturn(ipAddressModel);
        when(pageSettings.hasSetting("blockUserAfterXRequestsFromIP")).thenReturn(true);
        when(pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP")).thenReturn(10);

        IPCheckService ipCheckService = new IPCheckService(ipAddressDao);
        boolean permittedAccess = ipCheckService.isPermittedAccess(request, pageSettings);
        assertTrue(permittedAccess);
    }

    @Test
    public void testGetIPAddressAsLong() throws Exception {
        IPCheckService ipCheckService = new IPCheckService();

        assertIPAddressAsLong(ipCheckService, "localhost", 0);

        assertIPAddressAsLong(ipCheckService, "127.0.0.1", 2130706433);

        assertIPAddressAsLong(ipCheckService, "192.168.11.82", 3232238418L);

        assertIPAddressAsLong(ipCheckService, "FE80:0000:0000:0000:0202:B3FF:FE1E:8329", 0);
    }

    private void assertIPAddressAsLong(IPCheckService ipCheckService, String remoteIpAddress, long expectedResult) {
        when(request.getRemoteAddr()).thenReturn(remoteIpAddress);
        long ipAddressAsLong = ipCheckService.getIPAddressAsLong(request);

        assertEquals(expectedResult, ipAddressAsLong);
    }


}