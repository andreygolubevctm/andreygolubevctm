package com.ctm.web.core.services;

import org.junit.Test;

import static junit.framework.TestCase.assertNotNull;


public class EndpointTest {

    @Test
    public void testInstanceOf() throws Exception {
        assertNotNull(Endpoint.instanceOf("test"));
    }

    @Test(expected=java.lang.NullPointerException.class)
    public void testInstanceOfNull() throws Exception {
        Endpoint.instanceOf(null);
    }
}