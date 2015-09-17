package com.ctm.connectivity;

import com.ctm.logging.CorrelationIdUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest(SimpleConnection.class)
public class SimpleConnectionTest {

    private SimpleConnection simpleConnection;
    private HttpURLConnection connection;
    private String testUrl = "testUrl";

    @Before
    public void setup() throws Exception {
        URL url = PowerMockito.mock(URL.class);
        connection= mock(HttpURLConnection.class);
        InputStream stream = new ByteArrayInputStream("respone".getBytes(StandardCharsets.UTF_8));
        when(connection.getInputStream()).thenReturn(stream);
        when(url.openConnection()).thenReturn(connection);
        when(connection.getResponseCode()).thenReturn(200);
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