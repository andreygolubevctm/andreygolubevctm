package com.ctm.utils;

import org.junit.Test;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Created by lbuchanan on 18/12/2014.
 */
public class RequestUtilsTest {

    @Test
    public void shouldGetTransactionIdFromRequest(){
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getParameter("transactionId")).thenReturn("10000");
        Long result =  RequestUtils.getTransactionIdFromRequest(request);
        assertEquals(Long.valueOf(10000L), Long.valueOf(result));

        when(request.getParameter("transactionId")).thenReturn("meerkat");
        result =  RequestUtils.getTransactionIdFromRequest(request);
        assertEquals(Long.valueOf(-1L), result);
    }
}
