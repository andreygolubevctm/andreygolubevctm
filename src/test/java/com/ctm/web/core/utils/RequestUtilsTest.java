package com.ctm.web.core.utils;

import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class RequestUtilsTest {

    private HttpServletRequest request = mock(HttpServletRequest.class);

    @Test
    public void shouldGetTransactionIdFromRequest(){
        when(request.getParameter("transactionId")).thenReturn("10000");
        Long result =  RequestUtils.getTransactionIdFromRequest(request);
        assertEquals(Long.valueOf(10000L), Long.valueOf(result));

        when(request.getParameter("transactionId")).thenReturn("meerkat");
        result =  RequestUtils.getTransactionIdFromRequest(request);
        assertEquals(Long.valueOf(-1L), result);
    }

    @Test
    public void shouldGetTokenFromRequest(){
        String token = "token";
        when(request.getParameter(RequestUtils.VERIFICATION_TOKEN_PARAM)).thenReturn(token);
        String result = RequestUtils.getTokenFromRequest(request);
        assertEquals(token, result);
    }

    @Test
    public void shouldGetIsTestIp(){
        String localIP = "192.168.11.58";
        when(request.getLocalAddr()).thenReturn(localIP);
        assertTrue(RequestUtils.isTestIp(request));

        String nonLocalIP= "1.123.137.10";
        when(request.getLocalAddr()).thenReturn(nonLocalIP);
        assertFalse(RequestUtils.isTestIp(request));
    }
}
