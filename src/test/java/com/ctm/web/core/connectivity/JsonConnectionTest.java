package com.ctm.web.core.connectivity;

import junit.framework.TestCase;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class JsonConnectionTest extends TestCase {

    public void testSetHasCorrelationId() throws Exception {
        SimpleConnection conn = mock(SimpleConnection.class);
        JsonConnection jsonConnection = new JsonConnection(conn);
        jsonConnection.setHasCorrelationId(false);
        verify(conn).setHasCorrelationId(false);

        jsonConnection.setHasCorrelationId(true);
        verify(conn).setHasCorrelationId(true);

    }
}