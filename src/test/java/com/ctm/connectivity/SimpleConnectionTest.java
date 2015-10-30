package com.ctm.connectivity;

import com.ctm.web.core.logging.CorrelationIdUtils;
import com.ctm.test.TestUtils;
import com.ctm.web.core.connectivity.SimpleConnection;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.net.HttpURLConnection;
import java.net.URL;

@RunWith(PowerMockRunner.class)
@PrepareForTest(SimpleConnection.class)
public class SimpleConnectionTest {

    private SimpleConnection simpleConnection;
    private HttpURLConnection connection;
    private String testUrl = "testUrl";

    @Before
    public void setup() throws Exception {
        URL url = PowerMockito.mock(URL.class);
        connection = TestUtils.createFakeConnection();
        simpleConnection = new SimpleConnection();
        PowerMockito.whenNew(URL.class).withArguments(testUrl).thenReturn(url);
    }

    @Test
    public void testSetHasCorrelationId() throws Exception {
        simpleConnection.setHasCorrelationId(true);

        PowerMockito.spy(CorrelationIdUtils.class); //Used to be: PowerMockito.mockStatic(X.class);
        CorrelationIdUtils.setCorrelationIdHeader(connection);

        simpleConnection.get(testUrl);
        PowerMockito.verifyStatic(Mockito.times(1));
        CorrelationIdUtils.setCorrelationIdHeader(connection); //Now verifyStatic knows what to verify.


    }
    @Test
    public void shouldNotSendCorrelationIdIfSetToFalse() throws Exception {
        simpleConnection.setHasCorrelationId(false);
        PowerMockito.spy(CorrelationIdUtils.class); //Used to be: PowerMockito.mockStatic(X.class);
        CorrelationIdUtils.setCorrelationIdHeader(connection);

        simpleConnection.get(testUrl);
        PowerMockito.verifyStatic(Mockito.times(0));
        CorrelationIdUtils.setCorrelationIdHeader(connection); //Now verifyStatic knows what to verify.

    }
}