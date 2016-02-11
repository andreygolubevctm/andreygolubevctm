package com.ctm.web.life.apply.response;

import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class LifeApplyWebResponseResultsTest {



    @Test
    public void testGetSelection() throws Exception {
        Selection selection = new Selection.Builder().build();
        LifeApplyWebResponseResults results = new LifeApplyWebResponseResults.Builder()
                .selection(selection).build();
        assertEquals(selection , results.getSelection());
    }

    @Test
    public void testIsSuccess() throws Exception {
        boolean success = true;
        LifeApplyWebResponseResults results = new LifeApplyWebResponseResults.Builder()
                .success(success).build();
        assertEquals(success , results.isSuccess());

    }

    @Test
    public void testGetTransactionId() throws Exception {
        long transactionId = 1000L;
        LifeApplyWebResponseResults results = new LifeApplyWebResponseResults.Builder()
                .transactionId(transactionId).build();
        assertEquals(transactionId , results.getSelection());

    }
}