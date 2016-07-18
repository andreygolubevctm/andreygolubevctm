package com.ctm.web.life.apply.response;

import org.junit.Test;

import static org.junit.Assert.assertEquals;


public class LifeApplyWebResponseTest {

    @Test
    public void testGetResults() throws Exception {
        LifeApplyWebResponseResults results = new LifeApplyWebResponseResults.Builder().build();
        LifeApplyWebResponse response = new LifeApplyWebResponse.Builder().results(results).build();
        assertEquals(results, response.getResults());
    }
}