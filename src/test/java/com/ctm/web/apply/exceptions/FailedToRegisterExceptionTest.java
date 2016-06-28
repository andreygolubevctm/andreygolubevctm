package com.ctm.web.apply.exceptions;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.core.apply.exceptions.FailedToRegisterException;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import static org.junit.Assert.assertEquals;
import static org.mockito.MockitoAnnotations.initMocks;


public class FailedToRegisterExceptionTest {

    private FailedToRegisterException exception;
    @Mock
    private ApplyResponse applyResponse;
    private Long transactionId = 10000L;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        exception = new FailedToRegisterException( applyResponse,  transactionId);

    }

    @Test
    public void testGetApplyResponse() throws Exception {
        assertEquals(applyResponse , exception.getApplyResponse());
    }

    @Test
    public void testGetTransactionId() throws Exception {
        assertEquals(transactionId , exception.getTransactionId());

    }
}