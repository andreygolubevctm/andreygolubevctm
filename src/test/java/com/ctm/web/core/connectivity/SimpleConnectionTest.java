package com.ctm.web.core.connectivity;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.commonlogging.correlationid.CorrelationIdUtils;
import com.ctm.interfaces.common.types.CorrelationId;
import com.ctm.test.TestUtils;
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
    private CorrelationId correlationId = CorrelationId.instanceOf("testCorrelationId");

    @Before
    public void setup() throws Exception {
        URL url = PowerMockito.mock(URL.class);
        connection = TestUtils.createFakeConnection();
        simpleConnection = new SimpleConnection();
        LoggingVariables.setCorrelationId(correlationId);
        PowerMockito.whenNew(URL.class).withArguments(testUrl).thenReturn(url);
        URL url2 = PowerMockito.mock(URL.class);
        Mockito.when(url2.toString()).thenReturn("xxxx");
        PowerMockito.whenNew(URL.class).withArguments("http://localhost").thenReturn(url2);
        System.out.println("test here " + new URL("http://localhost").toString());
    }

    @Test
    public void testSetHasCorrelationId() throws Exception {
        simpleConnection.setHasCorrelationId(true);

        PowerMockito.spy(CorrelationIdUtils.class); //Used to be: PowerMockito.mockStatic(X.class);
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId);

        simpleConnection.get(testUrl);
        PowerMockito.verifyStatic(Mockito.times(1));
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId); //Now verifyStatic knows what to verify.
    }

    @Test
    public void shouldNotSendCorrelationIdIfSetToFalse() throws Exception {
        simpleConnection.setHasCorrelationId(false);
        PowerMockito.spy(CorrelationIdUtils.class); //Used to be: PowerMockito.mockStatic(X.class);
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId);

        simpleConnection.get(testUrl);
        PowerMockito.verifyStatic(Mockito.times(0));
        CorrelationIdUtils.setCorrelationIdRequestHeader(connection, correlationId); //Now verifyStatic knows what to verify.
    }
}