package com.ctm.web.core.model;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;

public class FatalErrorTest {

    @Test
    public void testGetProperty() throws Exception {
        FatalError fatalError = new FatalError();
        assertEquals("" ,fatalError.getProperty());
        assertNotEquals(null , fatalError.getProperty());

        fatalError.setProperty("test");
        assertEquals("test" , fatalError.getProperty());
    }
}