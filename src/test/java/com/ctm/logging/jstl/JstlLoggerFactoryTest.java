package com.ctm.logging.jstl;

import org.junit.Test;

import static org.junit.Assert.*;

public class JstlLoggerFactoryTest {

    @Test
    public void testGetLogger() throws Exception {
        assertLoggerName("travel_quote", "/travel_quote");
        assertLoggerName("tag.core.transaction", "/core/transaction.tag");
        assertLoggerName("jsp.travel_quote", "/travel_quote.jsp");
    }

    private void assertLoggerName(String expected, String source) {
        assertEquals(expected, JstlLoggerFactory.getLogger(source).getLogger().getName());
    }
}